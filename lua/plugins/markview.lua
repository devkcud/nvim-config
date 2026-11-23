return {
	"OXY2DEV/markview.nvim",
	opts = {
		preview = {
			callbacks = {
				on_attach = function(buf)
					if vim.bo[buf].filetype == "markdown" then
						require("markview.state").set_buffer_state(buf, { enable = false })
					end
				end,
			},
		},
	},
}
