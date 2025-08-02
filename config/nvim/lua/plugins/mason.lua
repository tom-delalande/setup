return {
  { "mason-org/mason.nvim", version = "^1.0.0" },
  { 
    "mason-org/mason-lspconfig.nvim", 
    version = "^1.0.0",
    opts = {
      automatic_enable = {
        exclude = {
          "clangd",
        }
      },
      ensure_installed = {
        "codelldb",
      },
    }
  },
}
