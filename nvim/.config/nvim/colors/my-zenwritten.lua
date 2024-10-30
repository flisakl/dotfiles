vim.opt.background = 'light'
vim.g.colors_name = 'my-zenwritten'

-- First we will need lush, and the colorscheme we wish to modify
local lush = require('lush')
local zenwritten = require('zenwritten')

-- we can apply modifications ontop of the existing colorscheme
local spec = lush.extends({zenwritten}).with(function()
  return {
    -- Use the existing Comment group in zenwritten, but adjust the gui attribute
    Comment { fg = "#0da308", gui = "italic" },
    Todo { fg = "#e30510", gui = "italic" },
  }
end)
lush(spec)
