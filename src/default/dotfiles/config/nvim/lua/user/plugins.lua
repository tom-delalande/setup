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
    spec = {
        { import = "plugins" },
        {
            "nvim-lualine/lualine.nvim",
            config = function()
                require("lualine").setup({
                    options = {
                        theme = "catppuccin",
                        section_separators = { left = '', right = '' },
                    }
                })
            end
        },
        {
            "nvim-tree/nvim-tree.lua",
            dependencies = {
                "nvim-tree/nvim-web-devicons"
            },
            config = function()
                require("nvim-tree").setup({
                    view = {
                        adaptive_size = true,
                        float = {
                            enable = true,
                        },
                    },
                })
            end
        },
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            config = function()
                require("catppuccin").setup({
                    flavour = "mocha",
                    transparent_background = true,
                })
                vim.cmd.colorscheme "catppuccin"
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = function(_)
                vim.cmd("TSUpdate")
            end,
            dependencies = {
                "nvim-treesitter/nvim-treesitter-context",
            },
            config = function()
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
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require('colorizer').setup()
            end
        },
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup()
            end
        },
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "rcarriga/nvim-dap-ui",
                "theHamsta/nvim-dap-virtual-text",
                "nvim-neotest/nvim-nio",
            },
            config = function()
            end
        },

        { "f-person/git-blame.nvim" },
        "kdheepak/lazygit.nvim",
        "tpope/vim-commentary",
        {
            "folke/trouble.nvim",
            config = function()
                require("trouble").setup()
            end,

        },
        {
            "windwp/nvim-autopairs",
            config = function()
                require("nvim-autopairs").setup()
            end
        },
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup({})
            end
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
                local default_setup = function(server)
                    require('lspconfig')[server].setup({
                        capabilities = lsp_capabilities,
                    })
                end
                require('mason-lspconfig').setup({
                    ensure_installed = {},
                    handlers = {
                        default_setup,
                    },
                })
            end
        },
        { "neovim/nvim-lspconfig" },
        {
            'hrsh7th/nvim-cmp',
            config = function()
                local cmp = require('cmp')
                local cmp_select = { behavior = cmp.SelectBehavior.Select }
                cmp.setup({
                    preselect = cmp.PreselectMode.None,
                    sources = {
                        { name = 'nvim_lsp' },
                        { name = 'nvim_lua' },
                        { name = 'buffer' },
                        { name = 'path' },
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                        ['<CR>'] = cmp.mapping.confirm({ select = false }),
                        ["<C-Space>"] = cmp.mapping.complete(), -- Must remove C-Space from MacOS Keyboard shortcuts
                    }),
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body)
                        end,
                    },
                })
            end,
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-nvim-lua',
            },
        },
        { 'L3MON4D3/LuaSnip' },
        "leafgarland/typescript-vim",
        {
            "evanleck/vim-svelte",
            dependencies = {
                "othree/html5.vim",
                "pangloss/vim-javascript"
            }
        },
        { "simrat39/rust-tools.nvim" },
        {
            "akinsho/flutter-tools.nvim",
            dependencies = {
                'nvim-lua/plenary.nvim',
                'stevearc/dressing.nvim',
            },
            config = function()
                require("flutter-tools").setup {}
            end
        },
        {
            "ziglang/zig.vim",
            config = function()
                vim.g.zig_fmt_autosave = 0
            end
        },
        "mbbill/undotree",
        "tpope/vim-surround",
        {
            "Pocco81/auto-save.nvim",
            config = function()
                require("auto-save").setup()
            end
        },
        {
            "rest-nvim/rest.nvim",
            dir = "~/dev/external/rest.nvim",
            dependencies = {
                "vhyrro/luarocks.nvim",
            },
            config = function()
                vim.g.rest_nvim = {
                    cookies = {
                        enable = false,
                    }
                }
            end
        },
    },
}, {})
