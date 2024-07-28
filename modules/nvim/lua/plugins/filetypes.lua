return {
  {
    "towolf/vim-helm",
    ft = { "yaml", "helm" },
    config = function()
      vim.api.nvim_create_augroup("helm_filetype", { clear = true })
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*/templates/*.yaml,*/templates/*.tpl,*.gotmpl,helmfile*.yaml",
        group = "helm_filetype",
        callback = function()
          vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
        end,
      })
    end,
  },
  {
    "lervag/vimtex",
    ft = { "latex" },
    config = function()
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_indent_conditionals = {}
      vim.g.vimtex_indent_on_ampersands = 0
      vim.g.vimtex_complete_close_braces = 1
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_imaps_leader = ";"
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "calops/hmts.nvim",
    version = "*",
  },
}
