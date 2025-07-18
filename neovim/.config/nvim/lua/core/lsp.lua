vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })
  end,
})

vim.lsp.enable({
  'nixd', 'lua_ls', 'pylsp', 'vue_ls', 'ts_ls', 'tailwindcss'
})
