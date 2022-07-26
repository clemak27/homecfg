-- ---------------------------------------- nvim-dap ---------------------------------------------------------

local M = {}

M.load = function()

  require('dap-go').setup()
  require("nvim-dap-virtual-text").setup()

  local opt = { noremap = true, silent = true }

  -- dap mappings
  vim.api.nvim_set_keymap("n", "<F5>", [[<Cmd>lua require'dap'.continue()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F6>", [[<Cmd>lua require'dap'.step_over()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F7>", [[<Cmd>lua require'dap'.step_into()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F8>", [[<Cmd>lua require'dap'.step_out()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F9>", [[<Cmd>lua require'dap'.toggle_breakpoint()<CR>]], opt)

  -- fzf mappings
  vim.api.nvim_set_keymap("n", "<Leader>i", [[<Cmd>lua require('fzf-lua').dap_commands()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>ic", [[<Cmd>lua require('fzf-lua').dap_configurations()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>ib", [[<Cmd>lua require('fzf-lua').dap_breakpoints()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>iv", [[<Cmd>lua require('fzf-lua').dap_variables()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>if", [[<Cmd>lua require('fzf-lua').dap_frames()<CR>]], opt)

end

return M
