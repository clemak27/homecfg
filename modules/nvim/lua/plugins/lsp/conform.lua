-- ---------------------------------------- conform --------------------------------------------------------
return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").formatters.prettiermd = vim.tbl_deep_extend("force", require("conform.formatters.prettier"), {
        args = {
          "--prose-wrap",
          "always",
          "--stdin-filepath",
          "$FILENAME",
        },
      })

      require("conform.formatters.shfmt").args = { "-i", "2", "-sr", "-ci", "-filename", "$FILENAME" }

      require("conform").setup({
        formatters_by_ft = {
          markdown = { "prettiermd" },
          yaml = { "yamlfmt" },
          lua = { "stylua" },
          nix = { "nixpkgs_fmt" },
          go = { "goimports", "gofumpt" },
          sh = { "shfmt" },
        },
      })
    end,
  },
}
