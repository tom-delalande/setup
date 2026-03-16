return {
  {
    "folke/snacks.nvim",
    -- opts will be merged with the parent spec
    opts = {
      picker = {
        hidden = true,
        ignored = true,
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
          explorer = {
            auto_close = true,
            hidden = true,
            ignored = true,
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
}
