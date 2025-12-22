local palette = require("utils.palette")

return {
	"rachartier/tiny-glimmer.nvim",
	opts = {
		overwrite = {
			yank = {
				enabled = true,
				default_animation = "fade",
			},
			paste = {
				enabled = true,
				default_animation = "reverse_fade",
			},
			search = {
				enabled = true,
				default_animation = "pulse",
			},
			undo = {
				enabled = true,
				default_animation = {
					name = "fade",
					settings = {
						from_color = palette.red,
					},
				},
			},
			redo = {
				enabled = true,
				default_animation = {
					name = "reverse_fade",
					settings = {
						to_color = palette.green,
					},
				},
			},
		},
		support = {
			substitute = {
				enabled = true,
				default_animation = "reverse_fade",
			},
		},
	},
}
