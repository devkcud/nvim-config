return {
	"j-hui/fidget.nvim",
	opts = {
		notification = {
			poll_rate = 10,
			filter = vim.log.levels.INFO,
			view = {
				stack_upwards = false,
			},
			window = {
				normal_hl = "Comment",
				winblend = 0,
				align = "top",
				avoid = { "neo-tree", "packer" },
			},
		},
	},
}
