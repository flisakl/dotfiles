local M = {}

local user_themes = {}

M.apply = function()
  local filepath = vim.fs.abspath("~/.cache/theme.json")
  local lines = io.open(filepath, "r"):read("a")
  local data = vim.json.decode(lines)
  local theme = user_themes[data.theme][data.variant]
  vim.cmd.colorscheme(theme)
end

M.setup = function(themes)
  user_themes = themes
  vim.api.nvim_create_autocmd({ "Signal" }, {
    pattern = { "SIGUSR1" },
    callback = function()
      vim.schedule(M.apply)
    end
  })

  M.apply()
end

return M
