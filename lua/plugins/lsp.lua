local csharp = require("utils.csharp")

local servers = vim.tbl_filter(function(server)
	return server ~= nil
end, {
	"lua_ls",

	"bashls",

	"clangd",
	csharp.roslyn_available() and nil or "omnisharp",
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
	"qmlls",

	"jsonls",
	"yamlls",
	"postgres_lsp",

	"marksman",
	"tinymist",
	"dockerls",
	"terraformls",
})

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

local lua_root_markers = {
	{ ".luarc.json", ".luarc.jsonc", ".emmyrc.json" },
	{ ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
	{ ".git" },
}

local lua_nvim_settings = {
	Lua = {
		codeLens = {
			enable = true,
		},
		completion = {
			callSnippet = "Replace",
		},
		diagnostics = {
			globals = { "vim" },
		},
		hint = {
			enable = true,
			semicolon = "Disable",
		},
		runtime = {
			version = "LuaJIT",
			path = {
				"lua/?.lua",
				"lua/?/init.lua",
			},
		},
		workspace = {
			checkThirdParty = false,
			library = {
				vim.env.VIMRUNTIME,
				"${3rd}/luv/library",
			},
		},
	},
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

local function clear_table(tbl)
	for key in pairs(tbl) do
		tbl[key] = nil
	end
end

local function lua_workspace_has_config(root_dir)
	if type(root_dir) ~= "string" or root_dir == "" then
		return false
	end

	return vim.uv.fs_stat(vim.fs.joinpath(root_dir, ".luarc.json")) ~= nil
		or vim.uv.fs_stat(vim.fs.joinpath(root_dir, ".luarc.jsonc")) ~= nil
end

local function lua_before_init(init_params, config)
	config.settings = config.settings or {}

	local root_dir = config.root_dir
	if type(root_dir) ~= "string" or root_dir == "" then
		local root_uri = init_params.rootUri
		if type(root_uri) == "string" then
			root_dir = vim.uri_to_fname(root_uri)
		end
	end

	if lua_workspace_has_config(root_dir) then
		clear_table(config.settings)
		return
	end

	config.settings.Lua = vim.tbl_deep_extend("force", config.settings.Lua or {}, lua_nvim_settings.Lua)
end

local function run_lsp_command(command, args)
	local suffix = args ~= "" and (" " .. args) or ""

	vim.cmd(("lsp %s%s"):format(command, suffix))
end

local function create_lsp_compat_commands()
	local commands = {
		{
			name = "LspStart",
			nargs = "?",
			callback = function(opts)
				run_lsp_command("enable", opts.args)
			end,
			desc = "Compatibility alias for :lsp enable",
		},
		{
			name = "LspStop",
			nargs = "?",
			bang = true,
			callback = function(opts)
				local clients = vim.lsp.get_clients({ bufnr = 0 })

				if opts.args ~= "" then
					clients = vim.tbl_filter(function(client)
						return client.name == opts.args
					end, clients)
				end

				for _, client in ipairs(clients) do
					client:stop(opts.bang)
				end
			end,
			desc = "Compatibility alias for the removed :LspStop command",
		},
		{
			name = "LspRestart",
			nargs = "?",
			callback = function(opts)
				run_lsp_command("restart", opts.args)
			end,
			desc = "Compatibility alias for :lsp restart",
		},
	}

	for _, command in ipairs(commands) do
		if vim.fn.exists(":" .. command.name) == 0 then
			vim.api.nvim_create_user_command(command.name, command.callback, {
				nargs = command.nargs,
				bang = command.bang,
				desc = command.desc,
			})
		end
	end

	if vim.fn.exists(":LspInfo") == 0 then
		vim.api.nvim_create_user_command("LspInfo", function()
			vim.cmd("checkhealth vim.lsp")
		end, {
			desc = "Compatibility alias for :checkhealth vim.lsp",
		})
	end

	if vim.fn.exists(":LspLog") == 0 then
		vim.api.nvim_create_user_command("LspLog", function()
			vim.cmd(("edit %s"):format(vim.fn.fnameescape(vim.lsp.log.get_filename())))
		end, {
			desc = "Open the Neovim LSP log file",
		})
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
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
				ui = {
					border = "rounded",
				},
			},
		},
		{ "b0o/schemastore.nvim" },
	},
	config = function(_, opts)
		require("mason-lspconfig").setup(opts)
		create_lsp_compat_commands()

		local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			vim.lsp.config("*", {
				capabilities = cmp_nvim_lsp.default_capabilities(),
			})
		end

		vim.lsp.config("lua_ls", {
			root_markers = lua_root_markers,
			before_init = lua_before_init,
			settings = {
				Lua = {},
			},
		})

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

		vim.lsp.config("yamlls", {
			settings = {
				redhat = {
					telemetry = {
						enabled = false,
					},
				},
				yaml = {
					format = {
						enable = true,
					},
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas({
						select = {
							"docker-compose.yml",
						},
					}),
				},
			},
		})

		vim.lsp.config("postgres_lsp", {
			root_markers = {
				"postgres-language-server.jsonc",
				".git",
			},
			workspace_required = false,
		})

		vim.lsp.config("qmlls", {
			root_markers = { ".qmlls.ini", "CMakeLists.txt", ".qmlproject", ".git" },
		})

		if vim.fn.exists(":CSharpInstallTools") == 0 then
			vim.api.nvim_create_user_command("CSharpInstallTools", function()
				vim.cmd("MasonInstall roslyn netcoredbg csharpier")
			end, {
				desc = "Install Roslyn, netcoredbg, and CSharpier via Mason",
			})
		end

		vim.lsp.enable(servers)
	end,
}
