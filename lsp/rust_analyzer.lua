return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
			},
			checkOnSave = {
				command = "clippy",
			},
			procMacro = {
				enable = true,
			},
			inlayHints = {
				enable = false,
			},
		},
	},
}
