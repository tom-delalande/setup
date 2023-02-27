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

local telescope_options = {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        file_ignore_patterns = { "node_modules" },
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    extensions_list = { "themes", "terms" },
}

require("lazy").setup({
    -- Visual
    "nvim-tree/nvim-web-devicons",
    {
        "joshdick/onedark.vim",
        config = function()
            vim.cmd "colorscheme onedark"
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
        "m-demare/hlargs.nvim",
        config = function()
            require('hlargs').setup({
                disable = function(_, bufnr)
                    if vim.b.semantic_tokens then
                        return true
                    end
                    local clients = vim.lsp.get_active_clients { bufnr = bufnr }
                    for _, c in pairs(clients) do
                        local caps = c.server_capabilities
                        if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
                            vim.b.semantic_tokens = true
                            return vim.b.semantic_tokens
                        end
                    end
                end,
            })
        end
    },
    "leafgarland/typescript-vim",
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup()
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
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            require('telescope').setup(telescope_options)
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup(
                {
                    sections = {
                        lualine_c = {
                            'filename',
                            'lsp_progress'
                        }
                    }
                }
            )
        end,
        dependencies = {
            -- { "arkav/lualine-lsp-progress" }
        }
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
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup()
        end,

    },
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
        'tzachar/cmp-tabnine',
        build = "./install.sh",
        dependencies = {
            { 'hrsh7th/nvim-cmp' },
        },
    },
    "evanleck/vim-svelte",
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettierd,
                },
            })
        end,
    },
    { "simrat39/rust-tools.nvim" },

    "numToStr/Comment.nvim",
    "mbbill/undotree",
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").add_default_mappings()
        end,
    },

    -- Utility
    "tpope/vim-surround",
    "nvim-lua/plenary.nvim",
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end
    },
}, {})
