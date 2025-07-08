-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.listchars = { tab = "»·", trail = "·", eol = "¬" }
vim.keymap.set("n", "Q", ":q<CR>", {})
