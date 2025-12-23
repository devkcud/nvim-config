return {
	cmd = { "ltex-ls-plus" },
	filetypes = {
		"bib",
		"gitcommit",
		"markdown",
		"org",
		"plaintex",
		"rst",
		"rnoweb",
		"tex",
		"pandoc",
		"quarto",
		"rmd",
		"context",
		"typst",
	},
	settings = {
		ltex = {
			language = "en-US",
			additionalRules = {
				enablePickyRules = true,
				motherTongue = "en-US",
			},
			checkFrequency = "save",
		},
	},
}
