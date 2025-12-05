return {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    -- snippets
    dependencies = {
	'rafamadriz/friendly-snippets'
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
	-- default: Ctrl-y to accept completion
	-- super-tab: Press tab to accept (similar to vscode)
	keymap = { preset = 'default' },
	appearance = {
	    -- use 'mono' for monospaced nerd font
	    nerd_font_variant = 'normal'
	},
	completion = {
	    -- default. Only show docs popup when manually triggered by ctrl-space
	    documentation = { auto_show = false }
	},
	sources = {
	    default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	fuzzy = { implementation = 'lua' }
    },
    opts_extend = { 'sources.default' }
}
