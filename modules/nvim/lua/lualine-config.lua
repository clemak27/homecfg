-- ---------------------------------------- lualine ------------------------------------------------------------

local M = {}

M.load = function()
  require("lualine").setup({
    options = {
      theme = "catppuccin",
      section_separators = "",
      component_separators = "|",
    },
    sections = {
      lualine_a = {},
      lualine_b = { "mode" },
      lualine_c = {
        "filename",
        "filetype",
      },
      lualine_x = {
        {
          "fileformat",
          icon = false,
        },
        "encoding",
        "progress",
        "location",
      },
      lualine_y = { { "branch", icon = "" } },
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  })
end

return M
