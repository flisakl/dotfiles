vim.opt.background = 'dark'
vim.g.colors_name = 'my-zenwritten'

-- First we will need lush, and the colorscheme we wish to modify
local lush = require('lush')
local zenwritten = require('zenwritten')

-- we can apply modifications ontop of the existing colorscheme
local spec = lush.extends({zenwritten}).with(function()
  return {
    -- Use the existing Comment group in zenwritten, but adjust the gui attribute
    Comment { fg = "#61eb57", gui = "italic" },
    Todo { fg = "#fa3232", gui = "italic" },
        -- TODO brighter colors
  }
end)
lush(spec)
