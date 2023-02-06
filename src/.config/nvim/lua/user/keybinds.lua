vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {})
vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile<CR>", {})
vim.keymap.set("n", "<C-g>", ":LazyGit<CR>", {})

vim.keymap.set("n", "Q", ":q<CR>", {})
vim.keymap.set("n", "Z", ":wqa<CR>", {})
vim.keymap.set("n", "<C-p>", ":AsyncRun git add -A && git commit --allow-empty-message -m '' && git push<CR>", {})

-- Vim Quality of Life
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})
vim.keymap.set("n", "n", "nzzzv", {})
vim.keymap.set("n", "N", "Nzzzv", {})

-- Telescope
vim.keymap.set("n", "<leader>fr", ":Telescope resume <CR>", {})
vim.keymap.set("n", "<leader>ff", ":Telescope find_files <CR>", {})
vim.keymap.set("n", "<leader>fw", ":Telescope live_grep <CR>", {})
vim.keymap.set("n", "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <CR>", {})
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles <CR>", {})
vim.keymap.set("n", "<leader>cm", ":Telescope git_commits <CR>", {})
vim.keymap.set("n", "<leader>gt", ":Telescope git_status <CR>", {})
vim.keymap.set("n", "<leader>xx", ":Telescope diagnostics <CR>", {})

-- LSP
vim.keymap.set("n", "<space>fd", vim.diagnostic.open_float, {})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, {})
vim.keymap.set("n", "<space>fl", ":silent %!prettier --stdin-filepath %<CR>", {})

local lsp = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>fm", function()
        vim.lsp.buf.format { async = true }
    end, bufopts)
    vim.keymap.set("n", "<space>rn", function()
        vim.lsp.buf.rename()
    end, bufopts)
end

return { lsp = lsp }
