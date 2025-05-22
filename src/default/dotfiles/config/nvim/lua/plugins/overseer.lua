return {
    {
        'stevearc/overseer.nvim',
        config = function()
            require('overseer').setup({
                templates = { "builtin" }
            })
        end
    }
}
