-- ---------------------------------------- mason --------------------------------------------------------

local M = {}

M.load = function()
  require("mason").setup({})
  require("mason-tool-installer").setup({
    ensure_installed = {
      -- LSP
      "bash-language-server",
      "css-lsp",
      "golangci-lint-langserver",
      "gopls",
      "html-lsp",
      { "jdtls", version = "1.12.0" },
      "json-lsp",
      "lua-language-server",
      "texlab",
      "typescript-language-server",
      "vetur-vls",
      "vim-language-server",
      "yaml-language-server",

      -- DAP
      "delve",

      -- Linter
      "shellcheck",
      "markdownlint",
      "vale",
      "yamllint",
      "hadolint",

      -- Fomatter
      "gofumpt",
      "goimports",
      "stylua",
    },

    auto_update = true,
  })
end

return M
