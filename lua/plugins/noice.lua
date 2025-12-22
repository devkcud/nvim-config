return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	---@type NoiceConfig
	opts = {
		lsp = {
			progress = {
				enabled = false,
			},
			documentation = {
				opts = {
					win_options = {
						conceallevel = 0,
					},
				},
			},
		},
		presets = {
			bottom_search = true,
			command_palette = false,
			lsp_doc_border = true,
		},
		cmdline = {
			view = "cmdline",
		},
	},
}
