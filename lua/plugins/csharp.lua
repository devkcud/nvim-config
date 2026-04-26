local csharp = require("utils.csharp")

local function roslyn_on_attach(client, bufnr)
	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if not client:supports_method("textDocument/codeLens") then
		return
	end

	local group = vim.api.nvim_create_augroup("CSharpRoslynCodeLens", { clear = false })

	vim.api.nvim_clear_autocmds({
		group = group,
		buffer = bufnr,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
		group = group,
		buffer = bufnr,
		callback = function()
			pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
		end,
	})

	pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
end

return {
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor", "cshtml" },
		cond = function()
			return csharp.roslyn_available()
		end,
		opts = {
			broad_search = true,
			silent = true,
		},
		config = function(_, opts)
			vim.lsp.config("roslyn", {
				on_attach = roslyn_on_attach,
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "fullSolution",
						dotnet_compiler_diagnostics_scope = "fullSolution",
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
						dotnet_enable_tests_code_lens = true,
					},
					["csharp|completion"] = {
						dotnet_provide_regex_completions = true,
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_show_name_completion_suggestions = true,
					},
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
				},
			})

			require("roslyn").setup(opts)
		end,
	},
	{
		"mfussenegger/nvim-dap",
		ft = { "cs" },
		config = function()
			local dap = require("dap")
			local netcoredbg = csharp.netcoredbg_path() or "netcoredbg"

			dap.adapters.netcoredbg = {
				type = "executable",
				command = netcoredbg,
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "netcoredbg",
					name = "Launch current project",
					request = "launch",
					program = csharp.select_debug_target,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					justMyCode = false,
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		ft = { "cs" },
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.disconnect.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		ft = { "cs" },
		opts = {
			commented = true,
			virt_text_pos = "inline",
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "cs" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"Issafalcon/neotest-dotnet",
		},
		config = function()
			require("neotest").setup({
				adapters = {
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
	},
}
