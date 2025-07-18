return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'sharkdp/fd',
        'nvim-tree/nvim-web-devicons',
    },
    config = function ()
        require('telescope').setup{
            defaults = {
                layout_strategy = 'horizontal',
                layout_config = {
                    width = 0.95,
                    preview_width = 0.65
                },
            },
        }
    end
}
