return {
  "ellisonleao/gruvbox.nvim",
  opts = {},
  name = "gruvbox",
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require("gruvbox").setup {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "hard", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    }
    vim.o.background = "dark" -- or "light" for light mode
    vim.cmd [[colorscheme gruvbox]]
  end,
}
