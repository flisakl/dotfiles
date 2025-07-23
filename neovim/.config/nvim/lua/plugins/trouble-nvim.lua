return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    auto_close = true,   -- auto close when there are no items
    auto_open = true,    -- auto open when there are items
    auto_preview = true, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = false,   -- auto jump to the item when there's only one
  },
  keys = {
    {
      "<leader>tt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
  }
}
