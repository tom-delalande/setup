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

local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#1e1e2e',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
}


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
    -- {
    --     "joshdick/onedark.vim",
    --     config = function()
    --         vim.cmd "colorscheme onedark"
    --     end
    -- },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            vim.cmd "colorscheme catppuccin"
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function(_)
            vim.cmd("TSUpdate")
        end,
        config = function()
            local config = require("nvim-treesitter.parsers").get_parser_configs()
            config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }
            vim.treesitter.language.register('templ', 'templ')
            require("nvim-treesitter.configs").setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
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
                    "terraform",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "yaml",
                    "html",
                }
            }
        end
    },
    { "vrischmann/tree-sitter-templ" },
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
    "fatih/vim-go",
    "leafgarland/typescript-vim",
    {
        "https://github.com/apple/pkl-neovim",
        lazy = true,
        event = "BufReadPre *.pkl",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        build = function()
            vim.cmd("TSInstall! pkl")
        end,
    },
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
                    options = {
                        theme = {
                            normal = {
                                a = { fg = colors.black, bg = colors.violet },
                                b = { fg = colors.white, bg = colors.grey },
                                c = { fg = colors.black, bg = colors.black },
                            },

                            insert = { a = { fg = colors.black, bg = colors.blue } },
                            visual = { a = { fg = colors.black, bg = colors.cyan } },
                            replace = { a = { fg = colors.black, bg = colors.red } },

                            inactive = {
                                a = { fg = colors.white, bg = colors.black },
                                b = { fg = colors.white, bg = colors.black },
                                c = { fg = colors.black, bg = colors.black },
                            },
                        },
                        component_separators = '|',
                        section_separators = { left = '', right = '' },
                    },
                    sections = {
                        lualine_a = {
                            { 'mode', separator = { left = '' }, right_padding = 2 },
                        },
                        lualine_b = { 'filename', 'branch' },
                        lualine_c = { 'fileformat' },
                        lualine_x = {},
                        lualine_y = { 'filetype', 'progress' },
                        lualine_z = {
                            { 'location', separator = { right = '' }, left_padding = 2 },
                        },
                    },
                    inactive_sections = {
                        lualine_a = { 'filename' },
                        lualine_b = {},
                        lualine_c = {},
                        lualine_x = {},
                        lualine_y = {},
                        lualine_z = { 'location' },
                    },
                    tabline = {},
                    extensions = {},
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
            require("transparent").setup()
            vim.cmd 'TransparentEnable'
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },

    {
        "weirongxu/plantuml-previewer.vim",
        dependencies = {
            "aklt/plantuml-syntax",
            "tyru/open-browser.vim",
        }
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("user.dap")
        end
    },

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
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                opts = {
                    ensure_installed = {
                        "js-debug-adapter",
                    }
                },
            },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        },
        config = function()

        end
    },
    {
        "evanleck/vim-svelte",
        dependencies = {
            "othree/html5.vim",
            "pangloss/vim-javascript"
        }
    },
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
    {
        "ziglang/zig.vim",
        config = function()
            vim.g.zig_fmt_autosave = 0
        end
    },
    {
        'akinsho/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = true,
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
    "tpope/vim-surround",
    "nvim-lua/plenary.nvim",
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
    }
}, {})
