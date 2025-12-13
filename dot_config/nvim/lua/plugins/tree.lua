return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
	"nvim-tree/nvim-web-devicons",
    },
    config = function()
	require("nvim-tree").setup {}

	local opts = { noremap = true, silent = true }
	vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
	vim.keymap.set('n', '<leader>f', ':NvimTreeFocus<CR>', opts)
    end,
}
