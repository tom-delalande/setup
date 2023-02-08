local keymaps = require("user.keybinds").lsp

local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
lsp.preset("recommended")

local formatting_disabled = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    keymaps(client, bufnr)
end

lsp.configure('tsserver', {
    on_attach = formatting_disabled,
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = false,
})

lsp.skip_server_setup({ 'denols' })
require("deno-nvim").setup({
    server = {
        on_attach = keymaps,
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        init_options = {
            enable = true,
            lint = true,
        }
    },
})

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'sumneko_lua',
    'rust_analyzer',
    'svelte',
    'tailwindcss',
    'terraformls',
    'jsonls',
})

lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})



lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


lsp.on_attach(keymaps)
lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
