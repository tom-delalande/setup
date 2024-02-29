local keymaps = require("user.keybinds").lsp

local lspzero = require("lsp-zero")
local lspconfig = require("lspconfig")
lspzero.preset("recommended")

local formatting_disabled = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    keymaps(client, bufnr)
end

lspzero.configure('tsserver', {
    on_attach = formatting_disabled,
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = true,
})

lspzero.configure('tailwindcss', {
    on_attach = keymaps,
    root_dir = lspconfig.util.root_pattern("go.mod", "package.json"),
    filetypes = { "html", "templ", "svelte" },
    single_file_support = true,
})

lspzero.skip_server_setup({ 'denols', 'rust-analyzer', 'kotlin_language_server' })

lspconfig.kotlin_language_server.setup({
    -- cmd = { "kotlin-language-server" },
    -- filetypes = { "kotlin" },
    on_attach = keymaps,
    -- root_dir = lspconfig.util.root_pattern("build.gradle.kts", "settings.gradle"),
})

require("rust-tools").setup({
    tools = {
        hover_actions = {
            max_width = 1,
            max_height = 1,
        },
    },
    server = {
        on_attach = keymaps,
        settings = {
            ["rust-analyzer"] = {
            }
        },
    }
})

lspzero.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'svelte',
    'tailwindcss',
    'terraformls',
    'jsonls',
    'rust_analyzer',
    'kotlin_language_server',
    'yamlls',
})

lspzero.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lspzero.configure('yamlls', {
    on_attach = formatting_disabled,
    settings = {
        yaml = {
            schemas = {
                kubernetes = "*.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                ["http://json.schemastore.org/circleciconfig.json"] = ".circleci/*",
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lspzero.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lspzero.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = {
        { name = "luasnip",  keyword_length = 2 },
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "path" },
        { name = "buffer",   keyword_length = 3 },
    }
})



lspzero.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lspzero.on_attach(keymaps)
lspzero.setup()

require("flutter-tools").setup {
    lsp = {
        on_attach = keymaps,
    }
}

vim.diagnostic.config({
    virtual_text = true
})
