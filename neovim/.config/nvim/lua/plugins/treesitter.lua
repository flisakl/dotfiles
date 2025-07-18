return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter")

        configs.setup({
            ensure_installed = {
                "lua", "vim", "markdown",
                "html", "javascript", "typescript", "css", "scss", "vue",
                "ruby", "python", "comment",
                "c",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
