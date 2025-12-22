return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
			validate = true,
			schemaStore = {
				enable = false,
				url = "",
			},
			hover = true,
			completion = true,
		},
	},
}
