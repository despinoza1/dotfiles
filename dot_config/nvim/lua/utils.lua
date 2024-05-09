local api = vim.api

local M = {}

M.opts = { noremap = true, silent = true }

function M.map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.keymap(mode, lhs, rhs, opts)
    local options = opts or {}
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.concat_list(list, seperator)
    if not list or #list == 0 then
        return ""
    end

    if #list == 1 then
        return list[1]
    end

    local result = list[1]
    for i = 2, #list do
        result = result .. seperator .. list[i]
    end

    return result
end

function M.run_command(command, arguments, verbose)
    local cmd = command

    if arguments then
        cmd = cmd .. " " .. M.concat_list(arguments, " ")
    end

    local output = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        print(output)

        if verbose then
            vim.api.nvim_err_writeln(cmd .. ": " .. vim.v.shell_error)
        end
        return
    end
end

return M
