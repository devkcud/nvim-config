local util = require("lspconfig.util")

return {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	root_dir = util.root_pattern(
		"package.json",
		"svelte.config.js",
		"svelte.config.ts",
		"pnpm-lock.yaml",
		"yarn.lock",
		".git"
	),
}
