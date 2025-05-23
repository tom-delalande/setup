return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
    },
    config = function()
        local dap = require("dap")
        local ui = require("dapui")

        ui.setup()

        require("nvim-dap-virtual-text").setup({})
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
        vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, {})
        vim.keymap.set("n", "<leader>k", function()
            ui.eval(nil, { enter = true })
        end, {})
        vim.keymap.set("n", "<leader>1", dap.continue, {})
        vim.keymap.set("n", "<leader>2", dap.step_into, {})
        vim.keymap.set("n", "<leader>3", dap.step_over, {})
        vim.keymap.set("n", "<leader>4", dap.step_out, {})
        vim.keymap.set("n", "<leader>5", dap.step_back, {})
        vim.keymap.set("n", "<leader>0", dap.restart, {})

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end
    end
}
