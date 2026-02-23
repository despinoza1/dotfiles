local dap = require("dap")

dap.adapters.debugpy = {
  type = "executable",
  command = "uv",
  args = { "run", "--with", "debugpy", "python", "-m", "debugpy.adapter" },
  options = {
    source_filetype = "python",
  },
}

dap.configurations = {
  python = {
    {
      name = "Launch file",
      type = "debugpy",
      request = "launch",
      program = "${file}",
    },
  },
}
