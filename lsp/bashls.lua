return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command)",
			shellcheckPath = "shellcheck",
			shellcheckArguments = {},
		},
	},
}
