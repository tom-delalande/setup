return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            require('telescope').setup({
                pickers = {
                    find_files = {
                        theme = "ivy",
                    },
                    live_grep = {
                        theme = "ivy",
                    },
                    old_files = {
                        theme = "ivy",
                    }
                },
                extensions = {
                    fzf = {}
                },
            })
            require('telescope').load_extension('fzf')
            vim.keymap.set("n", "<leader>fr", require('telescope.builtin').resume, {})
            vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files, {})
            vim.keymap.set("n", "<leader>fw", require('telescope.builtin').live_grep, {})
            vim.keymap.set("n", "<leader>fo", require('telescope.builtin').oldfiles, {})
            vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags, {})
            vim.keymap.set("n", "<leader>xx", require('telescope.builtin').diagnostics, {})
            vim.keymap.set("n", "<leader>cm", require('telescope.builtin').git_commits, {})
            vim.keymap.set("n", "<leader>gt", require('telescope.builtin').git_status, {})
            vim.keymap.set("n", "<leader>fa", require('telescope.builtin').find_files({ follow = true, no_ignore = true, hidden = true }) , {})
        end
    },
}
