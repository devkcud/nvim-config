local palette = require("utils.palette")

return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")

		notify.setup({
			background_colour = palette.dark_gray,
			fps = 60,
			icons = {
				DEBUG = "",
				ERROR = "",
				INFO = "",
				TRACE = "✎",
				WARN = "",
			},
			level = 2,
			minimum_width = 40,
			render = "default",
			stages = "slide",
			timeout = 2000,
			top_down = false,
		})

		vim.notify = notify
	end,
}
