return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
	require('telescope').setup({
	    pickers = {
		find_files = {
		    hidden = true,
		    follow = true,
		},
	    },
	    extensions = {
		fzf = {
		    fuzzy = true,
		    override_generic_sorter = true,
		    override_file_sorter = true,
		    case_mode = "smart_case",
		},
	    },
	})

	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

	require('telescope').load_extension('fzf')
    end
}
