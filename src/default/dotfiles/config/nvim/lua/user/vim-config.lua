vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.textwidth = 80

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.g.mapleader = " "
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.listchars = { tab = '»·', trail = '·', eol = '¬' }
vim.opt.list = true
vim.opt.clipboard = "unnamed"

vim.opt.guifont = { "RobotoMono Nerd Font", "h12" }
vim.cmd('autocmd BufNewFile,BufRead *.html set filetype=html')
vim.cmd('autocmd BufNewFile,BufRead *.html set syntax=html')
vim.cmd("highlight ColorColumn guibg=White")

