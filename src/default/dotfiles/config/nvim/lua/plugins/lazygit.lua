return {
    {
        "kdheepak/lazygit.nvim",
        config = function()
            vim.keymap.set("n", "<C-g>", ":LazyGit<CR>", {})
        end
    }
}
