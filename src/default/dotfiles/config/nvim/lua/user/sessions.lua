local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


local folders = {}

for dir in io.popen([[ls -d ~/dev/work/*/]]):lines() do
    table.insert(folders, dir)
end

for dir in io.popen([[ls -d ~/dev/personal/*/]]):lines() do
    table.insert(folders, dir)
end

local repositories = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Repositories",
        finder = finders.new_table {
            results = folders
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.fn.mkdir('.nvim', 'p')
                vim.cmd("mksession! .nvim/session")

                vim.fn.mkdir(selection[1] .. '.nvim', 'p')
                local new_file = selection[1] .. ".nvim/session"
                if (io.open(new_file, 'r') == nil) then
                    local file = io.open(new_file, 'w')
                    if (file ~= nil) then
                        file:write('cd ' .. selection[1])
                        file:close()
                    end
                end
                vim.cmd("source " .. new_file)
            end)
            return true
        end,
    }):find()
end


vim.keymap.set("n", "<leader>t", function()
    repositories(require("telescope.themes").get_dropdown())
end)
