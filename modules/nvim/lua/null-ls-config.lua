-- ---------------------------------------- null-ls --------------------------------------------------------

local M = {}

M.load = function()
  local null_ls = require("null-ls")
  require("null-ls").setup({
    sources = {
      null_ls.builtins.code_actions.eslint.with({
        prefer_local = "node_modules/.bin",
      }),
      null_ls.builtins.diagnostics.eslint.with({
        prefer_local = "node_modules/.bin",
      }),
      null_ls.builtins.formatting.eslint.with({
        prefer_local = "node_modules/.bin",
      }),
      null_ls.builtins.diagnostics.markdownlint.with({
        diagnostics_format = "[#{c}] #{m} (#{s})",
      }),
      null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "2", "-sr", "-ci" },
      }),
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.diagnostics.yamllint,
      null_ls.builtins.diagnostics.hadolint,
    },
  })
end

return M
