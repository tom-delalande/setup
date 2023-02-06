-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Visual
    "nvim-tree/nvim-web-devicons",
    {
        "bluz71/vim-moonfly-colors",
        config = function()
            vim.cmd "colorscheme moonfly"
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "dockerfile",
                    "fish",
                    "gitcommit",
                    "gitignore",
                    "java",
                    "json",
                    "kotlin",
                    "lua",
                    "rust",
                    "sql",
                    "svelte",
                    "terraform",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "yaml",
                }
            }
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                view = {
                    float = {
                        enable = true,
                    },
                }
            })
        end
    },
    "nvim-telescope/telescope.nvim",
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup()
        end
    },
    {
        "xiyaowong/nvim-transparent",
        config = function()

            require("transparent").setup {
                enable = true,
            }
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },

    "weirongxu/plantuml-previewer.vim",
    "aklt/plantuml-syntax",

    -- Functional
    -- -- Git
    "f-person/git-blame.nvim",
    "kdheepak/lazygit.nvim",
    "wellle/context.vim",
    "tpope/vim-commentary",
    "pwntester/octo.nvim",
    "sigmaSd/deno-nvim",
    {
        "ldelossa/gh.nvim",
        dependencies = {
            "ldelossa/litee.nvim",
        },
        config = function()
            require('litee.lib').setup()
            require('litee.gh').setup()
        end
    },

    -- --  LSP
    "jose-elias-alvarez/null-ls.nvim",
    "RishabhRD/nvim-lsputils",
    {
        "rmagatti/goto-preview",
        config = function()
            require('goto-preview').setup {}
        end
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            { 'williamboman/mason.nvim' }, -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-buffer' }, -- Optional
            { 'hrsh7th/cmp-path' }, -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' }, -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' }, -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        },
        config = function()

        end
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                },
            })
        end,
    },

    "numToStr/Comment.nvim",
    "mbbill/undotree",
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").add_default_mappings()
        end,
    },

    -- Utility
    "nvim-lua/plenary.nvim",
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end
    },
})
