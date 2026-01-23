local servers = {
	"lua_ls",

	"bashls",

	"clangd",
	"omnisharp",
	"basedpyright",
	"rust_analyzer",
	"gopls",

	"html",
	"cssls",
    "tailwindcss",

	"vimls",

	"ts_ls",
    "astro-language-server",
	"svelte",

	"jsonls",
	"yamlls",

	"marksman",
	"tinymist",
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = { ensure_installed = servers },
	dependencies = {
		{ "neovim/nvim-lspconfig" },
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({})
				vim.lsp.enable(servers)
			end,
		},
		{ "b0o/schemastore.nvim" },
	},
	config = function() end,
}
