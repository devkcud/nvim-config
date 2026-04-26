return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"lua",

			"dockerfile",
			"make",
			"bash",

			"c",
			"cpp",
			"c_sharp",
			"python",
			"rust",
			"go",
			"gomod",
			"gosum",

			"html",
			"css",
			"scss",

			"javascript",
			"typescript",
			"tsx",
			"svelte",

			"json",
			"xml",
			"yaml",
			"toml",

			"markdown",
			"markdown_inline",
			"latex",
			"typst",
			"dockerfile",
			"terraform",

			"sql",
		})

		require("treesitter-context").setup({
			line_numbers = true,
			separator = "─",
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "*" },
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
