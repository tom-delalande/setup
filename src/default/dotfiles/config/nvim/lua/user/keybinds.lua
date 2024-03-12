vim.keymap.set("n", "<leader>e", ":NvimTreeToggle <CR>", {})
vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile <CR>", {})
vim.keymap.set("n", "<CR>", "<CR><Cmd>cclose<CR>", { buffer = false, noremap = true, silent = true })
vim.keymap.set("n", "<C-g>", ":LazyGit<CR>", {})
vim.keymap.set("x", "gr", ":Gitsigns reset_hunk<CR>", {})

vim.keymap.set("n", "Q", ":q<CR>", {})

vim.keymap.set("n", "<leader>ff", ":Files <CR>", {})
vim.keymap.set("n", "<leader>fw", ":RG <CR>", {})
vim.keymap.set("n", "<leader>fo", ":History <CR>", {})
