-- ---------------------------------------- null-ls --------------------------------------------------------
return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local function file_exists(name)
        local f = io.open(name, "r")
        if f ~= nil then
          io.close(f)
          return true
        else
          return false
        end
      end

      local null_ls = require("null-ls")
      local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting

      local nullLsSources = {
        code_actions.gitsigns,
      }

      if file_exists(vim.fn.getcwd() .. "/node_modules/.bin/eslint") then
        table.insert(
          nullLsSources,
          code_actions.eslint.with({
            prefer_local = "node_modules/.bin",
          })
        )
        table.insert(
          nullLsSources,
          diagnostics.eslint.with({
            prefer_local = "node_modules/.bin",
          })
        )
        table.insert(
          nullLsSources,
          formatting.eslint.with({
            prefer_local = "node_modules/.bin",
          })
        )
      end

      if file_exists(vim.fn.getcwd() .. "/node_modules/.bin/prettier") then
        table.insert(
          nullLsSources,
          formatting.prettier.with({
            prefer_local = "node_modules/.bin",
          })
        )
      else
      end

      require("null-ls").setup({
        sources = nullLsSources,
      })
    end,
  },
}
