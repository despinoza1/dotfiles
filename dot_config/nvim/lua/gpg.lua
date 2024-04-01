local utils = require("utils")
local filetypes = require("plenary.filetype")

-- Code below based on GCBallesteros/jupytext.nvim

local M = {}

M.config = {
    passphrase = nil,
    passphrase_file = nil,
}

local function get_passphrase()
    -- FIXME: Passphrase is stored in history
    local user_input = vim.fn.input("Enter file's passphrase: ")
    return user_input
end

function M.gpg_decrypt(input_file, output_file, passphrase_arg)
    local cmd = "gpg "

    if not passphrase_arg then
        local passphrase = get_passphrase()
        passphrase_arg = "--passphrase '" .. passphrase .. "'"
    end

    utils.run_command(cmd, {
        passphrase_arg,
        "--pinentry-mode loopback",
        "--no-tty",
        "--output " .. output_file,
        "--decrypt " .. input_file,
    }, true)
end

function M.gpg_encrypt(event, passphrase_arg)
    local gpg_filename = event.match
    local filename = vim.fn.fnamemodify(gpg_filename, ":r")
    local cmd = "gpg "

    if not passphrase_arg then
        local passphrase = get_passphrase()
        passphrase_arg = "--passphrase '" .. passphrase .. "'"
    end

    vim.cmd.write({ filename, bang = true })
    utils.run_command(cmd, {
        passphrase_arg,
        "--pinentry-mode loopback",
        "--batch",
        "--yes",
        "--trust-model always",
        "--symmetric " .. filename,
    }, false)

    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value("modified", false, { buf = buf })

    local post_write = "BufWritePost"
    if event.event == "FileWriteCmd" then
        post_write = "FileWritePost"
    end
    vim.api.nvim_exec_autocmds(post_write, { pattern = gpg_filename })
end

local cleanup = function(gpg_filename, delete)
    local gpg_filename = vim.fn.resolve(vim.fn.expand(gpg_filename))
    local filename = vim.fn.fnamemodify(gpg_filename, ":r")

    if delete then
        vim.fn.delete(filename)
    end
end

local read_gpg = function(gpg_filename, gpg_passphrase)
    local gpg_filename = vim.fn.resolve(vim.fn.expand(gpg_filename))
    local filename = vim.fn.fnamemodify(gpg_filename, ":r")
    local extension = filetypes.detect(filename, { fs_access = false })

    local file_exists = vim.fn.filereadable(filename) == 1

    if not file_exists then
        M.gpg_decrypt(gpg_filename, filename, gpg_passphrase)
    end

    if vim.fn.filereadable(filename) then
        local file_contents = vim.fn.readfile(filename)

        table.insert(file_contents, 1, "")

        vim.api.nvim_buf_set_lines(0, 0, -1, false, file_contents)
    else
        error("Couldn't find local decrypted file.")
        return
    end

    vim.api.nvim_create_autocmd("BufUnload", {
        pattern = "<buffer>",
        group = "gpg-nvim",
        callback = function(ev)
            cleanup(ev.match, not file_exists)
        end,
    })

    vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd" }, {
        pattern = "<buffer>",
        group = "gpg-nvim",
        callback = function(ev)
            M.gpg_encrypt(ev, gpg_passphrase)
        end,
    })

    vim.api.nvim_command("setlocal fenc=utf-8 ft=" .. extension)

    local levels = vim.o.undolevels
    vim.o.undolevels = -1
    vim.api.nvim_command("silent 1delete")
    vim.o.undolevels = levels

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "<buffer>",
        group = "gpg-nvim",
        once = true,
        command = "redraw",
    })
end

local function setup(config)
    vim.validate({ config = { config, "table", true } })
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    local passphrase_arg = "--passphrase"
    if M.config.passphrase then
        passphrase_arg = passphrase_arg .. " '" .. M.config.passphrase .. "'"
    elseif M.config.passphrase_file then
        passphrase_arg = passphrase_arg .. "-file " .. M.config.passphrase_file
    else
        passphrase_arg = nil
    end

    vim.api.nvim_create_augroup("gpg-nvim", { clear = true })
    vim.api.nvim_create_autocmd("BufReadCmd", {
        pattern = { "*.gpg" },
        group = "gpg-nvim",
        callback = function(ev)
            read_gpg(ev.match, passphrase_arg)
        end,
    })
end

setup({
    passphrase_file = "/tmp/test",
    -- passphrase = "super-secret"
})

return M
