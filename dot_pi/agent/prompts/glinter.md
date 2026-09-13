---
description: Write simple git commit messages (Chris Beams + clear English). Use when committing, drafting COMMIT_EDITMSG, amending, squashing, or reviewing commit text.
---

# Glinter commit messages

A properly formed subject completes: **If applied, this commit will
\<subject\>**. Do not use Conventional Commits (`feat:`, `fix:`).

## Structure (must-fix)

| ID | Rule |
| --- | --- |
| S0 | Subject is not empty |
| S1 | Blank line between subject and body (if there is a body) |
| S3 | Subject ≤ 72 characters (error; column 73+) |
| S4 | Capitalize the subject. No leading space |
| S5 | No `.` `!` `?` at the end of the subject |
| B1 | Wrap body lines at 72 characters (URLs and trailers exempt) |

A one-line commit is fine. Git-generated subjects (`Merge `, `Revert `,
`fixup! `, `squash! `, `amend! `) are exempt.

## Mood and content

| ID | Rule |
| --- | --- |
| S6 | Imperative subject. Not `Fixed`, `Fixing`, `This`, `I`, `We` |
| S7 | Do not start with `WIP` |
| C1 | Body explains **why**, not how. The diff already shows how |

## Clear English

Prefer short, active, plain sentences. Do not score grade level.

| ID | Color | Rule |
| --- | --- | --- |
| H1 | yellow | Sentence > 20 words |
| H2 | red | Sentence > 30 words |
| H3 | blue | Adverbs (`really`, `quickly`, `very`, `too` + adjective) |
| H4 | green | Passive (`was written`, `were added`) |
| H5 | blue | Qualifiers (`maybe`, `I think`, `just`, `basically`) |
| H6 | purple | Weasel word with a simpler synonym |

`-ly` allowlist (do not flag): only, early, likely, daily, weekly, monthly,
yearly, family, apply, supply, reply, ally, assembly, fly, firefly,
dragonfly, butterfly.

Simpler words: utilize→use, leverage→use, facilitate→help, commence→start,
subsequently→then, therefore→so, attempt→try, obtain→get,
regarding→about, numerous→many, assist→help, accomplish→do,
demonstrate→show, terminate→end, remainder→rest, sufficient→enough,
necessitate→need, in order to→to, due to the fact that→because,
at this time→now, in the event that→if. Sentence-initial however→but.

## Pass

```
Fix overflow on long commit subjects

Subjects longer than 72 characters break git log and GitHub.
Cap the hard limit at 72 so the line stays a summary.
```

## Fail

```
fixed the thing.

Added a really comprehensive implementation that utilizes the new
framework so that highlighting can basically be applied in a way that is
very easily understood by users who might perhaps want to leverage it.
```


## Current Suggested Patch
Below is the current work in progress patch; only suggest a commit message
using the above guidance.

Last ten commits:
!`git --no-pager log --oneline -10 --no-color`

Patch:
!`git --no-pager diff --stat --no-color`
--FULL DIFF--
!`git --no-pager diff --no-color`
