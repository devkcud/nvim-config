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
	"terraformls",
}

local astro_root_markers = {
	"astro.config.mjs",
	"astro.config.ts",
	"astro.config.js",
	"astro.config.cjs",
	"package.json",
	"tsconfig.json",
	"jsconfig.json",
	".git",
}

local function astro_before_init(init_params, config)
	local init_options = vim.tbl_deep_extend("force", {
		typescript = {},
		contentIntellisense = true,
	}, init_params.initializationOptions or config.init_options or {})

	config.init_options = init_options
	init_params.initializationOptions = init_options

	local typescript = init_options.typescript
	if typescript.tsdk and typescript.tsdk ~= "" then
		return
	end

	local global_tsdk = vim.g.astro_tsdk or vim.g.tsdk
	if type(global_tsdk) == "string" and global_tsdk ~= "" then
		typescript.tsdk = global_tsdk
		return
	end

	local ok, mason_typescript = pcall(require, "mason-lspconfig.typescript")
	if ok then
		local install_dir = vim.fn.expand("$MASON/packages/astro-language-server")
		local server_path = mason_typescript.resolve_tsserver(install_dir, config.root_dir)
		local tsdk = mason_typescript.resolve_tsdk(install_dir, config.root_dir)

		if server_path and server_path ~= "" then
			typescript.serverPath = server_path
		end

		if tsdk and tsdk ~= "" then
			typescript.tsdk = tsdk
			return
		end
	end

	local util_ok, util = pcall(require, "lspconfig.util")
	if not util_ok then
		return
	end

	local tsdk = util.get_typescript_server_path(config.root_dir)
	if tsdk ~= "" then
		typescript.tsdk = tsdk
	end
end

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

		vim.lsp.config("astro", {
			root_markers = astro_root_markers,
			init_options = {
				typescript = {},
				contentIntellisense = true,
			},
			settings = {
				astro = {
					updateImportsOnFileMove = {
						enabled = false,
					},
				},
			},
			before_init = astro_before_init,
		})

		vim.lsp.enable(servers)
	end,
}
