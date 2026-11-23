return {
	"nvim-neotest/neotest",
	ft = { "cs", "java" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"Issafalcon/neotest-dotnet",
		"rcasia/neotest-java",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-java")({}),
				require("neotest-dotnet")({
					discovery_root = "solution",
					dap = {
						adapter_name = "netcoredbg",
						args = {
							justMyCode = false,
						},
					},
				}),
			},
		})
	end,
}
