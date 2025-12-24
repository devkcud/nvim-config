return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black", "isort" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			toml = { "taplo" },
			rust = { "rustfmt" },
			go = { "gofmt" },
			svelte = { "prettier" },
			cs = { "csharpier" },
		},
		format_on_save = false,
	},
}
