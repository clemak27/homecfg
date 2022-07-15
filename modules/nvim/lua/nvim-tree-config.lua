-- ---------------------------------------- nvim-tree -------------------------------------------------------

local M = {}

M.load = function()

  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      adaptive_size = true,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
    update_focused_file = {
      enable = true,
    },
  })

  local opt = { noremap = true, silent = true }

  vim.api.nvim_set_keymap("n", "<Leader>n", [[<Cmd>NvimTreeToggle<CR>]], opt)

end

return M
