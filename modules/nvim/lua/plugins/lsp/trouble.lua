return {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup({})
    local opt = { noremap = true, silent = true }

    vim.api.nvim_set_keymap("n", "<Leader>td", [[<Cmd>Trouble diagnostics<CR>]], opt)
    vim.api.nvim_set_keymap("n", "<Leader>tq", [[<Cmd>Trouble quickfix<CR>]], opt)
    vim.api.nvim_set_keymap("n", "<Leader>ts", [[<Cmd>Trouble lsp_document_symbols<CR>]], opt)
  end,
}
