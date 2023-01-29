-- ---------------------------------------- treesitter ---------------------------------------------------------
return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = "all",
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = false,
      },
      indent = {
        enable = true,
      },
      -- does not compile on macOS
      ignore_install = {
        "phpdoc",
      },
    })

    -- workaround issue with vim-markdown
    vim.api.nvim_exec(
      [[
    au BufNewFile,BufRead *.md TSBufDisable highlight
    ]],
      false
    )
  end,
  build = ":TSUpdate",
}
