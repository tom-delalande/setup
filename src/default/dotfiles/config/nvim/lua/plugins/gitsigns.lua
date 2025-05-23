return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()

            vim.keymap.set("x", "gr", ":Gitsigns reset_hunk<CR>", {})
            vim.keymap.set("x", "gs", ":Gitsigns stage_hunk<CR>", {})
            vim.keymap.set("x", "gp", ":Gitsigns preview_hunk_inline<CR>", {})
            vim.keymap.set("x", "gb", ":Gitsigns toggle_current_line_blame<CR>", {})
        end
    },
}
