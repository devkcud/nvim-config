return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	opts = {
		enabled = true,
		display = {
			theme = "atom",
			flavor = "accent",
		},
		editor = {
			tooltip = "Neovim",
		},
		idle = {
			enabled = false,
		},
		buttons = {
			{
				label = function()
					return "View Repository"
				end,
				url = function(opts)
					return opts.repo_url
				end,
			},
		},
	},
}
