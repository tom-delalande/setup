-- init.lua
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
    change_detection = { enabled = false },
    ui = {
        icons = {
            cmd = "",
            config = "",
            event = "",
            ft = "",
            init = "",
            keys = "",
            plugin = "",
            runtime = "",
            require = "",
            source = "",
            start = "",
            task = "",
            lazy = "",
        },
    },
})

vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full" -- don't insert, show options

-- line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- textwrap at 80 cols
vim.opt.tw = 80

vim.opt.guifont = { "RobotoMono Nerd Font", "h12" }
vim.opt.listchars = { tab = '»·', trail = '·', eol = '¬' }

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0

vim.opt.clipboard = "unnamed"
vim.opt.swapfile = false

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", {})
vim.keymap.set("n", "<leader>x", ":.lua<CR>", {})
vim.keymap.set("v", "<leader>x", ":lua<CR>", {})

vim.keymap.set("n", "Q", ":q<CR>", {})
