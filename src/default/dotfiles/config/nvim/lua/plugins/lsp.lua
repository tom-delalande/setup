local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.workspace = {
    didChangeWatchedFiles = {
        dynamicRegistration = true,
    },

}

return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')
            local configs = require('lspconfig.configs')


            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = {
                                "${3rd}/love2d/library"
                            }
                        }
                    }
                }
            })

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            configs.kotlin_lsp = {
                default_config = {
                    cmd = { "/Users/thomas-delalande/dev/personal/kotlin-0.252.16998/kotlin-lsp.sh", "--stdio" },
                    single_file_support = true,
                    filetypes = { "kotlin" },
                    root_markers = { "build.gradle", "build.gradle.kts", "pom.xml" },
                }
            }

            lspconfig.kotlin_lsp.setup({
                capabilities = capabilities,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = "LSP Actions",
                callback = function(event)
                    local telescope = require('telescope.builtin')
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                        { noremap = true, silent = true })
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<space>fm", function()
                        vim.keymap.set("n", "<space>fd", vim.diagnostic.open_float, {})
                        vim.lsp.buf.format { async = true }
                    end, opts)
                    vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
                    vim.keymap.set("n", "<space>D", telescope.lsp_type_definitions, opts)
                    vim.keymap.set("n", "gr", function()
                        telescope.lsp_references({ include_declaration = false })
                    end, opts)
                    vim.keymap.set("n", "<space>rn", function()
                        vim.lsp.buf.rename()
                    end, opts)

                    vim.keymap.set("n", "<space>ll", ":LspRestart <CR>", opts)
                end,
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "ts_ls" },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        }
    }
}
