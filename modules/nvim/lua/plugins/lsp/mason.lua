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
          -- java
          "jdtls",
          "gradle-language-server",
          "java-debug-adapter",
          "java-test",

          -- js
          "js-debug-adapter",
        },
      })
    end,
  },
}
