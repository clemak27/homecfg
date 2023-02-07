-- ---------------------------------------- mason --------------------------------------------------------
return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({})
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP
          "bash-language-server",
          "css-lsp",
          "gopls",
          "gradle-language-server",
          "html-lsp",
          { "jdtls", version = "1.12.0" },
          "json-lsp",
          "lua-language-server",
          "ltex-ls",
          "terraform-ls",
          "texlab",
          "typescript-language-server",
          "vetur-vls",
          "vim-language-server",
          "yaml-language-server",

          -- DAP
          "delve",
          "js-debug-adapter",

          -- Linter
          "golangci-lint",
          "hadolint",
          "markdownlint",
          "shellcheck",
          "yamllint",

          -- Fomatter
          "gofumpt",
          "goimports",
          "shfmt",
          "stylua",
        },
        auto_update = true,
      })
    end,
  },
}
