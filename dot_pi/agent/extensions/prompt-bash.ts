/**
 * Prompt Bash Expansion
 *
 * Expands `!`command`` blocks in prompts by running the bash command and
 * replacing the block with its output.
 *
 * Works in two places:
 *
 * 1. Prompt templates — when you invoke a template (e.g. `/review`) whose
 *    body contains `!`command`` blocks, the template is expanded (arguments
 *    included) and every command is executed before the prompt is sent:
 *
 *      ```markdown
 *      ---
 *      description: Review current proposed changes
 *      ---
 *      Review the contents of current proposed changes. Focus on bugs,
 *      code smells, and give suggestions for improvements.
 *
 *      Previous ten commits:
 *      !`git --no-pager log --oneline -n10 --no-color`
 *
 *      Proposed patch:
 *      !`git --no-pager diff --stat --no-color`
 *      --- DIFF ---
 *      !`git --no-pager diff --no-color`
 *      ```
 *
 * 2. Plain prompts — type or paste prompts containing `!`command`` blocks
 *    directly and each block is replaced with its output before sending.
 *
 * Syntax rules:
 * - A block is an exclamation mark immediately followed by a backtick-
 *   quoted command:  !`git status --short`
 * - Commands must be single-line (no backticks or newlines inside).
 * - The block is replaced by the command's stdout (stderr if stdout is
 *   empty), trimmed. Empty output becomes `[no output]`.
 * - Failing commands surface their stderr; if there is no output at all,
 *   a `[command failed: exit code N]` placeholder is inserted.
 * - Very large output is truncated (100KB / 4000 lines) with a note.
 *
 * What is NOT touched:
 * - Whole-line `!command` / `!!command` (pi's built-in user bash)
 * - `!{command}` blocks (handled by the separate inline-bash extension)
 * - Templates without `!`command`` blocks — pi expands those natively
 *
 * Security: commands run with your full system permissions. Only use this
 * in projects you trust.
 */
import { readFile } from "node:fs/promises";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const BASH_PATTERN = /!`([^`\n]+)`/g;
const COMMAND_TIMEOUT_MS = 120_000;
const MAX_OUTPUT_BYTES = 100_000;
const MAX_OUTPUT_LINES = 4000;

/** True if text contains at least one `!`command`` block. */
function hasBashBlock(text: string): boolean {
	BASH_PATTERN.lastIndex = 0;
	return BASH_PATTERN.test(text);
}

/** Split a template argument string into tokens, honoring quotes/escapes. */
function tokenizeArgs(input: string): string[] {
	const out: string[] = [];
	let current = "";
	let quote: string | null = null;
	let started = false;

	for (let i = 0; i < input.length; i++) {
		const ch = input[i];
		if (quote) {
			if (ch === quote) {
				quote = null;
			} else if (quote === '"' && ch === "\\" && i + 1 < input.length) {
				const next = input[++i];
				current += next === '"' || next === "\\" ? next : `\\${next}`;
			} else {
				current += ch;
			}
		} else if (ch === '"' || ch === "'") {
			quote = ch;
			started = true;
		} else if (ch === "\\" && i + 1 < input.length) {
			current += input[++i];
			started = true;
		} else if (ch === " " || ch === "\t") {
			if (started || current.length > 0) {
				out.push(current);
				current = "";
				started = false;
			}
		} else {
			current += ch;
		}
	}
	if (started || current.length > 0) out.push(current);
	return out;
}

/**
 * Expand pi template arguments: $1..$9, $@, $ARGUMENTS, ${N:-default},
 * ${@:-default}, ${ARGUMENTS:-default}, ${@:N}, ${@:N:L}.
 */
function expandArgs(template: string, args: string[]): string {
	const all = args.join(" ");
	let out = template;
	out = out.replace(/\$\{@:(\d+):(\d+)\}/g, (_m, n, l) =>
		args.slice(Number(n) - 1, Number(n) - 1 + Number(l)).join(" "),
	);
	out = out.replace(/\$\{@:(\d+)\}/g, (_m, n) => args.slice(Number(n) - 1).join(" "));
	out = out.replace(/\$\{@:-(.*?)\}/g, (_m, def: string) => (all.trim() ? all : def));
	out = out.replace(/\$\{ARGUMENTS:-(.*?)\}/g, (_m, def: string) => (all.trim() ? all : def));
	out = out.replace(/\$\{(\d+):-(.*?)\}/g, (_m, n: string, def: string) => args[Number(n) - 1] || def);
	out = out.replace(/\$@/g, all);
	out = out.replace(/\$ARGUMENTS\b/g, all);
	out = out.replace(/\$(\d+)/g, (_m, n: string) => args[Number(n) - 1] ?? "");
	return out;
}

/** Remove YAML frontmatter (`--- ... ---`) if present at the start. */
function stripFrontmatter(text: string): string {
	const m = text.match(/^\uFEFF?---[ \t]*\r?\n[\s\S]*?\r?\n---[ \t]*(?:\r?\n|$)/);
	return m ? text.slice(m[0].length) : text;
}

/** Cap output size for very large commands (e.g. big diffs). */
function truncateOutput(output: string): string {
	if (output.length <= MAX_OUTPUT_BYTES && output.split("\n").length <= MAX_OUTPUT_LINES) {
		return output;
	}
	const lines = output.split("\n");
	let kept = lines.slice(0, MAX_OUTPUT_LINES).join("\n");
	if (kept.length > MAX_OUTPUT_BYTES) {
		kept = kept.slice(0, MAX_OUTPUT_BYTES);
		const nl = kept.lastIndexOf("\n");
		if (nl > 0) kept = kept.slice(0, nl);
	}
	return `${kept}\n[output truncated: showing first ${Math.min(lines.length, MAX_OUTPUT_LINES)} of ${lines.length} lines]`;
}

/** Run one command and produce the replacement text. */
async function runBashCommand(pi: ExtensionAPI, command: string): Promise<string> {
	if (!command) return "[empty command]";
	let result: { stdout?: string; stderr?: string; code?: number | null; killed?: boolean };
	try {
		result = await pi.exec("bash", ["-c", command], { timeout: COMMAND_TIMEOUT_MS });
	} catch (error) {
		return `[error: ${error instanceof Error ? error.message : String(error)}]`;
	}
	if (result.killed) {
		return `[command timed out after ${COMMAND_TIMEOUT_MS / 1000}s]`;
	}
	const stdout = (result.stdout ?? "").trim();
	const stderr = (result.stderr ?? "").trim();
	const output = stdout || stderr;
	if (output) return truncateOutput(output);
	if (result.code === 0) return "[no output]";
	return `[command failed: exit code ${result.code ?? "unknown"}]`;
}

/** Replace every `!`command`` block in text with its output. */
async function expandBashBlocks(pi: ExtensionAPI, text: string): Promise<{ text: string; count: number }> {
	BASH_PATTERN.lastIndex = 0;
	const matches = Array.from(text.matchAll(BASH_PATTERN));
	if (matches.length === 0) return { text, count: 0 };

	let result = "";
	let last = 0;
	for (const match of matches) {
		const index = match.index ?? 0;
		result += text.slice(last, index);
		result += await runBashCommand(pi, match[1].trim());
		last = index + match[0].length;
	}
	result += text.slice(last);
	return { text: result, count: matches.length };
}

/**
 * If input is a prompt template invocation whose template body contains
 * `!`command`` blocks, expand arguments + bash and return the final prompt.
 * Returns undefined when it does not apply (let pi handle it natively).
 */
async function tryExpandTemplate(pi: ExtensionAPI, input: string): Promise<string | undefined> {
	try {
		const t = input.trim();
		if (!t.startsWith("/")) return undefined;
		const space = t.search(/\s/);
		const name = (space === -1 ? t : t.slice(0, space)).slice(1);
		const argText = space === -1 ? "" : t.slice(space + 1).trim();

		const commands = pi.getCommands?.();
		const template = commands?.find((c) => c.name === name && c.source === "prompt");
		const path = template?.sourceInfo?.path;
		if (!path) return undefined;

		const body = stripFrontmatter(await readFile(path, "utf8"));
		if (!hasBashBlock(body)) return undefined; // let pi expand natively

		const args = tokenizeArgs(argText);
		const expanded = expandArgs(body, args);
		const { text } = await expandBashBlocks(pi, expanded);
		return text;
	} catch {
		return undefined;
	}
}

export default function (pi: ExtensionAPI) {
	pi.on("input", async (event, ctx) => {
		const text = typeof event.text === "string" ? event.text : "";
		if (!text) return { action: "continue" };
		const trimmed = text.trimStart();

		// Leave pi's built-in whole-line `!command` / `!!command` bash alone.
		if (trimmed.startsWith("!")) return { action: "continue" };

		const isTemplateCall = /^\/[A-Za-z0-9_.:-]+(\s|$)/.test(trimmed);

		try {
			if (isTemplateCall) {
				const expanded = await tryExpandTemplate(pi, text);
				if (expanded === undefined) return { action: "continue" };
				if (ctx.hasUI) {
					ctx.ui.notify("prompt-bash: expanded inline bash command(s) in prompt template", "info");
				}
				return { action: "transform", text: expanded, images: event.images };
			}

			if (!hasBashBlock(text)) return { action: "continue" };
			const { text: expanded, count } = await expandBashBlocks(pi, text);
			if (count === 0) return { action: "continue" };
			if (ctx.hasUI) {
				ctx.ui.notify(`prompt-bash: expanded ${count} inline bash command(s)`, "info");
			}
			return { action: "transform", text: expanded, images: event.images };
		} catch {
			// Fail open: let pi process the input normally.
			return { action: "continue" };
		}
	});
}
