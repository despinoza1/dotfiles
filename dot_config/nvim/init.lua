require("options")
require("autocmds")
require("qft")
require("lazy_init")
require("mappings")
require("gpg").setup({
  passphrase_file = "~/.config/notes/passphrase",
})
