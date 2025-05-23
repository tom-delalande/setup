return { 
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

		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle <CR>", {})
		vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile <CR>", {})
            end
        }
}
