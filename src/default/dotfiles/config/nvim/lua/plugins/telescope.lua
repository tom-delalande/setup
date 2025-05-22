return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            local default_theme = "ivy"
            require('telescope').setup({
                pickers = {
                    find_files = { theme = default_theme },
                    live_grep = { theme = default_theme },
                    old_files = { theme = default_theme },
                    help_tags = { theme = default_theme },
                    diagnostics = { theme = default_theme },
                    git_commits = { theme = default_theme },
                    git_status = { theme = default_theme },
                    commands = { theme = default_theme },
                    builtin = { theme = default_theme },
                },
                extensions = {
                    fzf = {},
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    },
                },
            })

            require('telescope').load_extension('fzf')
            require("telescope").load_extension("ui-select")

            vim.keymap.set("n", "<leader>fr", require('telescope.builtin').resume, {})
            vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files, {})
            vim.keymap.set("n", "<leader>fw", require('telescope.builtin').live_grep, {})
            vim.keymap.set("n", "<leader>fo", require('telescope.builtin').oldfiles, {})
            vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags, {})
            vim.keymap.set("n", "<leader>xx", require('telescope.builtin').diagnostics, {})
            vim.keymap.set("n", "<leader>cm", require('telescope.builtin').git_commits, {})
            vim.keymap.set("n", "<leader>gt", require('telescope.builtin').git_status, {})
            vim.keymap.set("n", "<leader>fc", require('telescope.builtin').commands, {})
            vim.keymap.set("n", "<leader>fb", require('telescope.builtin').builtin, {})
            vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags, {})
            vim.keymap.set("n", "<leader>fa", function()
                require('telescope.builtin').find_files({ follow = true, no_ignore = true, hidden = true })
            end, {})
        end
    },
}
