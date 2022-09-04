-- ---------------------------------------- colorscheme ------------------------------------------------------

local M = {}

M.load = function()


  local onedarkpro = require('onedarkpro')
  onedarkpro.setup({
    theme = 'onedark',
    colors = {
      bg = "#1e1e1e"
    },
    hlgroups = {
      TSField = { fg = "${red}" }
    },
    options = {
      cursorline = true,
    }
  })
  onedarkpro.load()

end

return M
