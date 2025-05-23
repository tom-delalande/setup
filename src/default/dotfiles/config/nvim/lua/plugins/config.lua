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
        },
      },
    },
  },
}
