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
	"astro",
	"svelte",

	"jsonls",
	"yamlls",

	"marksman",
	"tinymist",
	"dockerls",
}

---@type LazySpec
return {
	"williamboman/mason-lspconfig.nvim",
	---@type MasonLspconfigSettings
	opts = { ensure_installed = servers, automatic_enable = {} },
	dependencies = {
		{ "neovim/nvim-lspconfig" },
		{
			"williamboman/mason.nvim",
			---@type MasonSettings
			opts = {
				ui = {
					border = "rounded",
				},
			},
		},
		{ "b0o/schemastore.nvim" },
	},
	config = function(_, opts)
		require("mason-lspconfig").setup(opts)
		vim.lsp.enable(servers)
	end,
}
