vim.filetype.add({
  extension = {
    env = "dotenv",
    pyx = "cython",
    pyd = "cython",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})
