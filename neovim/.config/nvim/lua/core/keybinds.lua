-- cycle through buffers
vim.keymap.set('n', '<Tab>', ':bn<cr>', {})
vim.keymap.set('n', '<S-Tab>', ':bp<cr>', {})

-- close buffer
vim.keymap.set('n', '<leader>d', ':bd<cr>', {})
vim.keymap.set('n', '<left>', ':vertical resize -2<cr>', {})

-- resize splits
vim.keymap.set('n', '<right>', ':vertical resize +2<cr>', {})
vim.keymap.set('n', '<down>', ':resize -2<cr>', {})
vim.keymap.set('n', '<up>', ':resize +2<cr>', {})

-- telescope pickers
local tele = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tele.find_files, {})
vim.keymap.set('n', '<leader>fg', tele.live_grep, {})
vim.keymap.set('n', '<leader>fb', tele.buffers, {})
vim.keymap.set('n', '<leader>fh', tele.help_tags, {})

-- toggle file tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', {})

-- open neogit
vim.keymap.set('n', '<leader>n', ':Neogit<cr>', {})

-- LSP saga
vim.keymap.set('n', '<leader>sf', ':Lspsaga finder<cr>', {})
vim.keymap.set('n', '<leader>spd', ':Lspsaga peek_definition<cr>', {})
vim.keymap.set('n', '<leader>spt', ':Lspsaga peek_type_definition<cr>', {})
vim.keymap.set('n', '<leader>sca', ':Lspsaga code_action<cr>', {})
vim.keymap.set('n', '<leader>sic', ':Lspsaga incoming_calls<cr>', {})
vim.keymap.set('n', '<leader>soc', ':Lspsaga outgoing_calls<cr>', {})

-- LSP
vim.keymap.set('n', 'gca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition, {})

-- Gitsigns
vim.keymap.set('n', 'shs', ':Gitsigns stage_hunk<cr>', {})
vim.keymap.set('n', 'shr', ':Gitsigns reset_hunk<cr>', {})
vim.keymap.set('n', 'shp', ':Gitsigns preview_hunk<cr>', {})
vim.keymap.set('n', 'shn', ':Gitsigns nav_hunk next<cr>', {})
