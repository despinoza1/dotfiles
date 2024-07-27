local neorg = require("neorg.core")

local modules = neorg.modules
local module = modules.create("external.wtoc")

---@class Heading
---@field node_type string
---@field level number
---@field title string
---@field range { row_start: number, column_start: number, row_end: number, column_end: number }

---@class Location
---@field line number
---@field file Path
---@field headings Heading[]

---@alias FileHeadings { [string]: Heading[] }

module.setup = function()
  return {
    success = true,
    requires = {
      "core.ui",
      "core.integrations.treesitter",
      "core.dirman",
      "core.dirman.utils",
    },
  }
end

local dirman ---@type core.dirman
local ts ---@type core.integrations.treesitter
module.load = function()
  ts = module.required["core.integrations.treesitter"]
  dirman = module.required["core.dirman"]

  modules.await("core.neorgcmd", function(neorgcmd)
    neorgcmd.add_commands_from_table({
      ["wtoc"] = {
        min_args = 0,
        condition = "norg",
        name = "wtoc",
      },
    })
  end)
end

module.config.public = {
  level = 3,
  split = "left",
}


local locations = {} ---@type Location
local query_string = [[
[
  (heading1
   title: (paragraph_segment) @heading1
  )
  (heading2
   title: (paragraph_segment) @heading2
  )
  (heading3
   title: (paragraph_segment) @heading3
  )
  (heading4
   title: (paragraph_segment) @heading4
  )
  (heading5
   title: (paragraph_segment) @heading5
  )
  (heading6
   title: (paragraph_segment) @heading6
  )
]
]]

--- Get headings for a file
---@param file PathlibPath|string|number
---@return Heading[]|nil
local get_headings = function(file)
  local parser
  local file_src

  if type(file) ~= "string" or type(file) ~= "number" then
    file = tostring(file)
  end

  if type(file) == "string" then
    if vim.fn.bufexists(file) == 1 then
      file = vim.uri_to_bufnr(vim.uri_from_fname(file))
    else
      file_src = io.open(file, "r"):read("*a")
      parser = vim.treesitter.get_string_parser(file_src, "norg")
    end
  end

  if type(file) == "number" then
    if file == 0 then
      file = vim.api.nvim_get_current_buf()
    end
    parser = vim.treesitter.get_parser(file, "norg")
    file_src = file
  end
  if not parser then
    return nil
  end

  local tree = parser:parse()[1]
  local query = vim.treesitter.query.parse("norg", query_string)

  local headings = {}
  for _, match in query:iter_matches(tree:root(), file_src) do
    for id, node in pairs(match) do
      local heading = query.captures[id]

      local level = 0
      if heading == "heading1" then
        level = 1
      elseif heading == "heading2" then
        level = 2
      elseif heading == "heading3" then
        level = 3
      elseif heading == "heading4" then
        level = 4
      elseif heading == "heading5" then
        level = 5
      elseif heading == "heading6" then
        level = 6
      end

      table.insert(headings, {
        node_type = heading,
        level = level,
        title = ts.get_node_text(node, file_src),
        range = ts.get_node_range(node),
      })
    end
  end

  return headings
end

--- Format file/headings pairs into a ToC
---@param file_headings FileHeadings
---@return string[]
local create_ui_data = function (file_headings)
  locations = {} ---@type Location[]
  local ui_data = {}
  table.insert(ui_data, "Table of Contents")

  local current_line = 1
  for file, headings in pairs(file_headings) do
    table.insert(ui_data, "*" .. file .. "*")
    table.insert(locations, {
      line = current_line,
      file = file,
    })

    current_line = current_line + 1
    for _, heading in ipairs(headings) do
      if heading.level > module.config.public.level then
        goto continue
      end

      local line = ""
      if heading.level == 1 then
        line = line .. "* "
      elseif heading.level == 2 then
        line = line .. "** "
      elseif heading.level == 3 then
        line = line .. "*** "
      elseif heading.level == 4 then
        line = line .. "**** "
      elseif heading.level == 5 then
        line = line .. "***** "
      elseif heading.level == 6 then
        line = line .. "****** "
      end
      line = line .. heading.title

      table.insert(locations, {
        line = current_line,
        file = file,
        headings = heading,
      })
      table.insert(ui_data, line)
      current_line = current_line + 1

      ::continue::
    end
  end

  return ui_data
end

--- Get file/headings pairs in the Workspace
---@return FileHeadings|nil
local  get_workspace_file_headings = function()
  local workspace = dirman.get_current_workspace()[1]

  local files = dirman.get_norg_files(workspace)
  if files == nil then
    return nil
  end

  local file_headings = {}
  for _, file in ipairs(files) do
    local headings = get_headings(file)

    if headings ~= nil then
      file_headings[tostring(file)] = headings
    end
  end

  return file_headings
end

--- Update ToC buffer contents
---@param ui_buffer number
local update_ui = function (ui_buffer)
  local file_headings = get_workspace_file_headings()
  if file_headings == nil then
    return
  end

  local ui_data = create_ui_data(file_headings)

  vim.bo[ui_buffer].modifiable = true
  vim.api.nvim_buf_set_lines(ui_buffer, 0, -1, true, ui_data)
  vim.bo[ui_buffer].modifiable = false
end


module.events.subscribed = {
  ["core.neorgcmd"] = {
    ["wtoc"] = true,
  },
}


module.on_event = function(event)
  if event.type == "core.neorgcmd.events.wtoc" then
    local file_headings = get_workspace_file_headings()
    if file_headings == nil then
      return
    end

    local ui_buffer, ui_window = module.required["core.ui"].create_vsplit(
      "wtoc",
      true,
      { ft = "norg" },
      { split = module.config.public.split, win = 0, style = "minimal" }
    )

    local ui_data = create_ui_data(file_headings)

    local ui_wo = vim.wo[ui_window]
    ui_wo.scrolloff = 999
    ui_wo.conceallevel = 2
    ui_wo.foldmethod = "expr"
    ui_wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    ui_wo.foldlevel = 99

    vim.api.nvim_buf_set_lines(ui_buffer, 0, -1, true, ui_data)

    vim.bo[ui_buffer].modifiable = false

    vim.api.nvim_buf_set_keymap(ui_buffer, "n", "<CR>", "", {
      callback = function()
        local curline = vim.api.nvim_win_get_cursor(ui_window)
        if curline[1] == 1 then
          return
        end

        local location = locations[curline[1] - 1]
        vim.cmd.wincmd("p")

        vim.cmd.edit(location.file)
        if location.headings ~= nil then
          vim.api.nvim_win_set_cursor(
            0,
            { location.headings.range.row_start + 1, location.headings.range.column_start }
          )
        end
      end,
    })

    vim.api.nvim_buf_set_keymap(ui_buffer, "n", "r", "", {
      callback = function()
        update_ui(ui_buffer)
      end,
    })

    vim.api.nvim_buf_set_keymap(ui_buffer, "n", "+", "", {
      callback = function()
        module.config.public.level = module.config.public.level + 1
        if module.config.public.level > 6 then
          module.config.public.level = 6
        end
        update_ui(ui_buffer)
      end,
    })
    vim.api.nvim_buf_set_keymap(ui_buffer, "n", "-", "", {
      callback = function()
        module.config.public.level = module.config.public.level - 1
        if module.config.public.level < 1 then
          module.config.public.level = 1
        end
        update_ui(ui_buffer)
      end,
    })

    vim.api.nvim_buf_set_keymap(ui_buffer, "n", "q", "", {
      callback = function()
        vim.cmd.wincmd("q")
      end,
    })
  end
end

return module
