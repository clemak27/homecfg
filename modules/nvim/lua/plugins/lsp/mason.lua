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
          "gopls",
          "gradle-language-server",
          "jdtls",
          "terraform-ls",
          "typescript-language-server",
          "vetur-vls",
          "vim-language-server",

          -- DAP
          "delve",
          "js-debug-adapter",
          "java-debug-adapter",
          "java-test",

          -- Linter
          "golangci-lint",

          -- Formatter
          "gofumpt",
          "goimports",
        },
        -- https://github.com/williamboman/mason.nvim/issues/916
        -- auto_update = true,
      })
    end,
  },
}
