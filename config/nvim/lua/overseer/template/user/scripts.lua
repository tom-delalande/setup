local files = require("overseer.files")

return {
  generator = function(opts, cb)
    local dir = vim.fn.getcwd()
    local scripts = vim.tbl_filter(function(filename)
      return filename:match("%.sh$")
    end, files.list_files(dir .. "/scripts/"))
    local ret = {}
    for _, filename in ipairs(scripts) do
      table.insert(ret, {
        name = filename,
        params = {
          args = { optional = true, type = "list", delimiter = " " },
        },
        builder = function(params)
          return {
            cmd = { files.join(dir .. "/scripts/", filename) },
            args = params.args,
          }
        end,
      })
    end

    cb(ret)
  end,
}
