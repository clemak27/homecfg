-- ---------------------------------------- nvim-lint ------------------------------------------------------------

local M = {}

M.load = function()

  local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
  end

  local linters = {
    markdown = { 'markdownlint' },
  }

  local valeFile = vim.fn.getcwd() .. "/.vale.ini"
  if file_exists(valeFile) then
    table.insert(linters['markdown'], 'vale')
  end

  require('lint').linters_by_ft = linters

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })

end
return M
