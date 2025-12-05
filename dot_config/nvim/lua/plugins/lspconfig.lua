return {
    'neovim/nvim-lspconfig',
    dependencies = {
	-- mason automatically installs language servers and stuff
	{
	    'mason-org/mason.nvim',
	    opts = {
		ui = {
		    icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		    },
		},
	    },
	},
	-- bridges mason with lspconfig
	'mason-org/mason-lspconfig.nvim',
	-- install and upgrade third-party tools automatically
	'WhoIsSethDaniel/mason-tool-installer.nvim',
	-- status updates for LSP
	{ 'j-hui/fidget.nvim', opts = {} },
	-- blink completion plugin
	'saghen/blink.cmp',
    },
    config = function()
	-- This function is run when opening a new file that is associated
	-- with an LSP.
	vim.api.nvim_create_autocmd('LspAttach', {
	    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	    callback = function(event)
		-- Create a function to define mappings concisely
		local map = function(keys, func, desc, mode)
		    mode = mode or 'n'
		    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc})
		end

		-- omnifunc fallback
		vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- rename variable under cursor
		map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

		-- Execute code action
		map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

		-- find references
		map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

		-- Jump to implementation
		map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementations')

		-- Jump to definition. Press Ctrl-t to jump back
		map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

		-- Jump to declaration, i.e. jump to header
		map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

		-- Fuzzy find symbols in current document
		map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

		-- Fuzzy find symbols in workspace
		map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

		-- Jump to type of word under cursor
		map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

		map("gsh", vim.lsp.buf.signature_help, "Signature Help")

		map("<leader>ld", require("telescope.builtin").diagnostics, "Diagnostics")
	    end
	})

	local capabilities = require('blink.cmp').get_lsp_capabilities()

	local servers = {
	    clangd = {
		-- Telescope compatibility fix
		cmd = { "clangd", "--offset-encoding=utf-16" },
	    },
	    lua_ls = {
		cmd = { "lua-language-server" },  -- Manual install due to problems on Arch
		settings = {
		    Lua = {
			workspace = { checkThirdParty = false },
			diagnostics = { globals = { "vim" } },
			completion = { callSnippet = "Replace" },
		    },
		},
	    },
	    basedpyright = {
		settings = {
		    basedpyright = {
			typeCheckingMode = "standard",
		    },
		},
	    },
	}

	local ensure_installed = {}
	-- Remove lua_ls here because we manually add it at the end
	for name, _ in pairs(servers) do
	    if name ~= "lua_ls" then
		table.insert(ensure_installed, name)
	    end
	end

	vim.list_extend(ensure_installed, {
	    'stylua',
	})

	require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

	require('mason-lspconfig').setup({
	    automatic_installation = false,
	})

	-- register configs
	for name, config in pairs(servers) do
	    config.capabilities = vim.tbl_deep_extend(
		'force', {}, capabilities, config.capabilities or {}
	    )
	    vim.lsp.config(name, config)
	end

	-- enable all servers
	vim.lsp.enable(vim.tbl_keys(servers))
    end,
}
