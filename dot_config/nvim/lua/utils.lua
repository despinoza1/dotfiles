local M = {}

M.opts = { noremap = true, silent = true }

function M.extend_default_opts(opts)
  return vim.tbl_extend("force", M.opts, opts)
end

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = M.extend_default_opts(opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.keymap(mode, lhs, func, opts)
  local options = opts or {}
  vim.keymap.set(mode, lhs, func, options)
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

function M.get_cmd_output(cmd, cwd)
  if type(cmd) ~= "table" then
    vim.notify("Command must be a table", 3, { title = "Error" })
    return {}
  end

  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = require("plenary.job")
    :new({
      command = command,
      args = cmd,
      cwd = cwd,
      on_stderr = function(_, data)
        table.insert(stderr, data)
      end,
    })
    :sync()

  return stdout, ret, stderr
end

-- Copied from `scottmckendry/Windots`

function M.write_to_file(file, lines)
  if not lines or #lines == 0 then
    return
  end
  local buf = io.open(file, "w")
  for _, line in ipairs(lines) do
    if buf ~= nil then
      buf:write(line .. "\n")
    end
  end

  if buf ~= nil then
    buf:close()
  end
end

function M.diff_file(file)
  local pos = vim.fn.getpos(".")
  local current_file = vim.fn.expand("%:p")
  vim.cmd("edit " .. file)
  vim.cmd("vert diffsplit " .. current_file)
  vim.fn.setpos(".", pos)
end

function M.diff_file_from_history(commit, file_path)
  local extension = vim.fn.fnamemodify(file_path, ":e") == "" and ""
    or "." .. vim.fn.fnamemodify(file_path, ":e")
  local temp_file_path = os.tmpname() .. extension

  local cmd = { "git", "show", commit .. ":" .. file_path }
  local out = M.get_cmd_output(cmd)

  M.write_to_file(temp_file_path, out)
  M.diff_file(temp_file_path)
end

function M.telescope_diff_from_history()
  local current_file = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:."):gsub("\\", "/")
  require("telescope.builtin").git_commits({
    git_command = {
      "git",
      "log",
      "--pretty=oneline",
      "--abbrev-commit",
      "--follow",
      "--",
      current_file,
    },
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        vim.cmd("DiffviewOpen " .. selection.value .. "..HEAD")
        -- M.diff_file_from_history(selection.value, current_file)
      end)
      return true
    end,
  })
end

return M
