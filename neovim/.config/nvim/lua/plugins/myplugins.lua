return {

  {
    dir = "~/.config/nvim/myplugins/switcher.nvim",
    priority = 999,
    name = "switcher",
    config = function()
      require("switcher").setup({
        catppuccin = {
          light = "catppuccin-latte",
          dark = "catppuccin-mocha"
        },
      })
    end
  }
}
