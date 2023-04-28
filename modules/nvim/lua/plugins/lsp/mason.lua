-- ---------------------------------------- mason --------------------------------------------------------
return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP
          "bash-language-server",
          "css-lsp",
          "gopls",
          "gradle-language-server",
          "html-lsp",
          "jdtls",
          "json-lsp",
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
          "java-debug-adapter",
          "java-test",

          -- Linter
          "golangci-lint",
          "hadolint",
          "markdownlint",
          "shellcheck",
          "yamllint",

          -- Formatter
          "gofumpt",
          "goimports",
          "shfmt",
          "stylua",
        },
        -- https://github.com/williamboman/mason.nvim/issues/916
        -- auto_update = true,
      })
    end,
  },
}
