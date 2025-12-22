return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@type ibl.config
	opts = {
		enabled = true,
		indent = { char = "┊" },
		debounce = 100,
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
			highlight = { "IndentBlanklineContextChar" },
			priority = 200,
			include = {
				node_type = {
					["*"] = { "*" },
				},
			},
			exclude = {},
		},
	},
}
