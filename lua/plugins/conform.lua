return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black", "isort" },
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			html = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			json = { "prettierd", "prettier" },
			jsonc = { "prettierd", "prettier" },
			markdown = { "prettierd", "prettier" },
			yaml = { "prettierd", "prettier" },
			toml = { "taplo" },
			rust = { "rustfmt" },
			go = { "gofmt" },
			svelte = { "prettierd", "prettier" },
			cs = { "csharpier" },
		},
		format_on_save = false,
	},
}
