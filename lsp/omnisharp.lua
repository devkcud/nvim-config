return {
	cmd = { "omnisharp" },
	filetypes = { "cs", "vb" },
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
			OrganizeImports = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
		},
	},
    root_dir = require("lspconfig.util").root_pattern(
        ".omnisharp.json",
        ".git",
        "global.json",
        "*.sln",
        "*.csproj"
    ),
}
