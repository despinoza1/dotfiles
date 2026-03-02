-- Copied from nvim-treesitter-textobjects master branch
local M = {}

local tstext_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

local set_last_move = function(move_fn, opts, ...)
  if type(move_fn) ~= "function" then
    print("move_fn has to be a function but got " .. vim.inspect(move_fn))
    return false
  end

  if type(opts) ~= "table" then
    print("opts has to be a table but got " .. vim.inspect(opts))
    return false
  elseif opts.forward == nil then
    print("opts has to include a `forward` boolean but got " .. vim.inspect(opts))
    return false
  end

  tstext_repeat_move.last_move =
    { func = move_fn, opts = vim.deepcopy(opts), additional_args = { ... } }
  return true
end

M.make_repeatable_move_pair = function(forward_move_fn, backward_move_fn)
  local general_repeatable_move_fn = function(opts, ...)
    if opts.forward then
      forward_move_fn(...)
    else
      backward_move_fn(...)
    end
  end

  local repeatable_forward_move_fn = function(...)
    set_last_move(general_repeatable_move_fn, { forward = true }, ...)
    forward_move_fn(...)
  end

  local repeatable_backward_move_fn = function(...)
    set_last_move(general_repeatable_move_fn, { forward = false }, ...)
    backward_move_fn(...)
  end

  return repeatable_forward_move_fn, repeatable_backward_move_fn
end

return M
