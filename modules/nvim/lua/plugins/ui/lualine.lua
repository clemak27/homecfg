-- ---------------------------------------- lualine ------------------------------------------------------------

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    {
      "SmiteshP/nvim-navic",
      config = function()
        require("nvim-navic").setup({
          lsp = {
            auto_attach = true,
            preference = nil,
          },
          highlight = true,
        })
      end,
    },
  },
  config = function()
    local C = require("catppuccin.palettes").get_palette("mocha")
    local function navic()
      local navic = require("nvim-navic")
      if navic.is_available() then
        return navic.get_location(opts, bufnr)
      else
        return ""
      end
    end

    require("lualine").setup({
      options = {
        theme = "catppuccin",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "mode",
            color = function(section)
              if vim.fn.mode() == "n" then
                return { fg = C.blue, gui = "bold" }
              elseif vim.fn.mode() == "i" then
                return { fg = C.teal, gui = "bold" }
              elseif vim.fn.mode() == "t" then
                return { fg = C.teal, gui = "bold" }
              elseif vim.fn.mode() == "c" then
                return { fg = C.peach, gui = "bold" }
              elseif vim.fn.mode() == "v" then
                return { fg = C.mauve, gui = "bold" }
              elseif vim.fn.mode() == "r" then
                return { fg = C.red, gui = "bold" }
              end
            end,
          },
          "filetype",
          {
            "filename",
            separator = "|",
          },
          {
            navic,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            separator = "|",
          },
          "searchcount",
          "location",
          "diff",
          { "branch", icon = "", color = { fg = C.green, gui = "bold" } },
        },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
