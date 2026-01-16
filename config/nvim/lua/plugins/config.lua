return {
  {
    "folke/snacks.nvim",
    -- opts will be merged with the parent spec
    opts = {
      picker = {
        sources = {
          explorer = {
            auto_close = true,
          },
          projects = {
            dev = { "~/dev", "~/projects", "~/dev/work", "~/dev/personal" },
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = {
          selection = {
            preselect = false,
            -- auto_insert = false,
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "typescript-language-server",
        "gopls",
        "kotlin-lsp",
        "clangd",
        "zls",
        "tailwindcss-language-server",
      },
    },
  },
}
