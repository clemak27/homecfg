-- ---------------------------------------- markdown --------------------------------------------------------
return {
  {
    "preservim/vim-markdown",
    ft = { "markdown" },
    config = function()
      vim.o.conceallevel = 2
      vim.api.nvim_exec(
        [[
        let g:vim_markdown_folding_disabled = 1
        let g:vim_markdown_emphasis_multiline = 0
        let g:vim_markdown_conceal_code_blocks = 0
        let g:vim_markdown_new_list_item_indent = 2
        ]],
        false
      )
      vim.api.nvim_set_keymap("n", "<Leader>ww", [[<Cmd>e ~/Notes/index.md<CR>]], { noremap = true, silent = true })
    end,
  },
  { "godlygeek/tabular", ft = { "markdown" } },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_echo_preview_url = true
    end,
    build = "cd app && yarn install",
  },
}
