-- ---------------------------------------- null-ls --------------------------------------------------------
return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting

      require("null-ls").setup({
        sources = {
          code_actions.eslint.with({
            prefer_local = "node_modules/.bin",
          }),
          diagnostics.eslint.with({
            prefer_local = "node_modules/.bin",
          }),
          formatting.eslint.with({
            prefer_local = "node_modules/.bin",
          }),
          diagnostics.markdownlint.with({
            diagnostics_format = "[#{c}] #{m} (#{s})",
          }),
          code_actions.shellcheck,
          formatting.shfmt.with({
            extra_args = { "-i", "2", "-sr", "-ci" },
          }),
          formatting.stylua,
          formatting.goimports,
          diagnostics.yamllint,
          diagnostics.hadolint,
        },
      })

      vim.api.nvim_create_user_command("NullLsToggle", function()
        require("null-ls").toggle({})
      end, {})
    end,
  },
}
