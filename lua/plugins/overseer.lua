return {
  "stevearc/overseer.nvim",
  opts = {},
  config = function()
    require("overseer").setup {
      strategy = "toggleterm",
      templates = { "builtin", "user.cpp_build", "user.cpp_run" },
    }
  end,
  dependencies = {
    {
      "akinsho/toggleterm.nvim",
      name = "toggleterm",
    },
  },
}
