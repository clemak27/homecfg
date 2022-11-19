-- ---------------------------------------- treesitter ---------------------------------------------------------

local M = {}

M.load = function()
  local parser_dir = vim.fn.stdpath("data") .. "site/parser"

  require("nvim-treesitter.configs").setup({
    -- ensure_installed = "all",
    parser_install_dir = parser_dir,
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

  -- add parser dir to rtp
  vim.opt.runtimepath:append(parser_dir)
  --
  -- workaround issue with vim-markdown
  vim.api.nvim_exec(
    [[
    au BufNewFile,BufRead *.md TSBufDisable highlight
    ]],
    false
  )
end

return M
