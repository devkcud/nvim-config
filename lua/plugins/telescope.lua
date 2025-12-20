local palette = require("utils.palette")

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				FIX = {
					color = palette.red,
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
				},
				TODO = {
					color = palette.cyan,
				},
				HACK = {
					color = palette.yellow,
				},
				WARN = {
					color = palette.yellow,
					alt = { "WARNING", "XXX" },
				},
				PERF = {
					color = palette.green,
					alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
				},
				NOTE = {
					color = palette.light_gray,
					alt = { "INFO", "QUESTION" },
				},
				TEST = {
					color = palette.medium_gray,
					alt = { "TESTING", "EXPECT", "EXPECTED" },
				},
			},
		},
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
				file_ignore_patterns = {
					".git/",
					"node_modules/",
					"dist/",
					"build/",
					"target/",
					".vscode/",
					".idea/",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob=!**/.git/*",
						"--glob=!**/.idea/*",
						"--glob=!**/.vscode/*",
						"--glob=!**/build/*",
						"--glob=!**/dist/*",
						"--glob=!**/yarn.lock",
						"--glob=!**/bun.lock",
						"--glob=!**/package-lock.json",
					},
				},
			},
		})

		telescope.load_extension("todo-comments")
	end,
}
