local utils = require("core.keymaps.utils")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

---@param category string
---@param items Keymap[]
local function join_keymaps(category, items)
	for _, keymaps in ipairs({ items }) do
		for _, keymap in ipairs(keymaps) do
			utils.define_keymap(category, keymap)
		end
	end
end

-- Basic Keymaps
join_keymaps("General", {
	{
		mode = { "normal", "visual", "visual-block" },
		key = "j",
		func = "gj",
		desc = "Move down by display line",
	},
	{
		mode = { "normal", "visual", "visual-block" },
		key = "k",
		func = "gk",
		desc = "Move up by display line",
	},
	{
		mode = "normal",
		key = "<leader>w",
		func = "set wrap!",
		desc = "Toggle Wrap",
		kind = "function",
	},

	{
		mode = { "visual", "visual-block" },
		key = "<",
		func = "<gv",
		desc = "Indent Left and Reselect",
	},
	{
		mode = { "visual", "visual-block" },
		key = ">",
		func = ">gv",
		desc = "Indent Right and Reselect",
	},

	{
		mode = "visual",
		key = "p",
		func = "'_dP",
		desc = "Paste without Overwriting Register",
	},

	{
		mode = "normal",
		key = "<F1>",
		func = "Neotree toggle",
		desc = "Toggle File Explorer",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<F3>",
		func = function()
			local ok, which_key = pcall(require, "which-key")
			if ok then
				which_key.show()
			end
		end,
		desc = "Show Which-Key",
	},

	{
		mode = "normal",
		key = "<C-y>",
		func = function()
			local ok, conform = pcall(require, "conform")
			if ok then
				conform.format({ bufnr = vim.api.nvim_get_current_buf() })
			end
		end,
		desc = "Format File with Conform",
	},
	{
		mode = "normal",
		key = "<leader>e",
		func = "edit!",
		desc = "Reload Current File",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>q",
		func = "wqa",
		desc = "Save and Quit All",
		kind = "function",
	},
})

-- Movement Keymaps
join_keymaps("Movement", {
	{
		mode = "normal",
		key = "<A-q>",
		func = function()
			local ok, neoscroll = pcall(require, "neoscroll")
			if ok then
				neoscroll.ctrl_u({ duration = 250 })
			end
		end,
		desc = "Scroll Up Half Page",
	},
	{
		mode = "normal",
		key = "<A-e>",
		func = function()
			local ok, neoscroll = pcall(require, "neoscroll")
			if ok then
				neoscroll.ctrl_d({ duration = 250 })
			end
		end,
		desc = "Scroll Down Half Page",
	},
	{
		mode = "normal",
		key = "<A-a>",
		func = function()
			local ok, neoscroll = pcall(require, "neoscroll")
			if ok then
				neoscroll.ctrl_b({ duration = 250 })
			end
		end,
		desc = "Scroll Up Full Page",
	},
	{
		mode = "normal",
		key = "<A-d>",
		func = function()
			local ok, neoscroll = pcall(require, "neoscroll")
			if ok then
				neoscroll.ctrl_f({ duration = 250 })
			end
		end,
		desc = "Scroll Down Full Page",
	},
	{
		mode = "normal",
		key = "<A-k>",
		func = function()
			local ok, neoscroll = pcall(require, "neoscroll")
			if ok then
				neoscroll.scroll(-0.1, { duration = 100 })
			end
		end,
		desc = "Scroll Up Smoothly",
	},
	{
		mode = "normal",
		key = "<A-j>",
		func = function()
			local ok, neoscroll = pcall(require, "neoscroll")
			if ok then
				neoscroll.scroll(0.1, { duration = 100 })
			end
		end,
		desc = "Scroll Down Smoothly",
	},
})

-- Tabs Keymaps
join_keymaps("Tabs", {
	{
		mode = "normal",
		key = "<C-n>",
		func = "tabnew",
		desc = "Open New Tab",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<C-j>",
		func = "tabprevious",
		desc = "Go to Previous Tab",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<C-k>",
		func = "tabnext",
		desc = "Go to Next Tab",
		kind = "function",
	},
	{
		mode = "normal",
		key = "H",
		func = "tabm -1",
		desc = "Move Tab Left",
		kind = "function",
	},
	{
		mode = "normal",
		key = "L",
		func = "tabm +1",
		desc = "Move Tab Right",
		kind = "function",
	},
})

-- Toggle Keymaps
join_keymaps("Toggle", {
	{
		mode = "normal",
		key = "<leader>Td",
		func = function()
			local ok, discord = pcall(require, "cord.api.command")
			if ok then
				discord.toggle_presence()
			end
		end,
		desc = "Toggle Discord Presence",
	},
	{
		mode = "normal",
		key = "<leader>Tc",
		func = function()
			local function get_status()
				return vim.api.nvim_exec2("Copilot status", { output = true }).output
			end

			if get_status():match("Disabled") then
				vim.api.nvim_exec2("Copilot enable", { output = false })
				print("Copilot Enabled")
			else
				vim.api.nvim_exec2("Copilot disable", { output = false })
				print("Copilot Disabled")
			end
		end,
		desc = "Toggle GitHub Copilot",
	},
	{
		mode = "normal",
		key = "<leader>Tu",
		func = function()
			vim.cmd("UfoDetach")
			vim.cmd("UfoAttach")
		end,
		desc = "Refresh Ufo Folds",
	},
})

-- Markview Keymaps
join_keymaps("Markview", {
	{
		mode = "normal",
		key = "<leader>mt",
		func = "Markview Toggle",
		desc = "Toggle markdown preview",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>ms",
		func = "Markview splitToggle",
		desc = "Toggle markdown preview in split view",
		kind = "function",
	},
})

-- Telescope Keymaps
join_keymaps("Telescope", {
	{
		mode = "normal",
		key = "<leader>tf",
		func = "Telescope find_files",
		desc = "Telescope Find Files",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>tg",
		func = "Telescope live_grep",
		desc = "Telescope Live Grep",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>tm",
		func = "Telescope git_status",
		desc = "Telescope Git Status",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>tt",
		func = function()
			local ok, telescope = pcall(require, "telescope")
			if ok then
				telescope.extensions["todo-comments"].todo()
			end
		end,
		desc = "Telescope Todo Comments",
	},
})

-- Harpoon Keymaps
-- NOTE: Defined in lua/plugins/harpoon.lua

-- Ufo Keymaps
join_keymaps("UFO", {
	{
		mode = "normal",
		key = "zr",
		func = function()
			local ok, ufo = pcall(require, "ufo")
			if ok then
				ufo.openAllFolds()
			end
		end,
		desc = "Open All Folds",
	},
	{
		mode = "normal",
		key = "zm",
		func = function()
			local ok, ufo = pcall(require, "ufo")
			if ok then
				ufo.closeAllFolds()
			end
		end,
		desc = "Close All Folds",
	},
})

-- Obsidian Keymaps
join_keymaps("Obsidian", {
	{
		mode = "normal",
		key = "<leader>ow",
		func = "Obsidian workspace",
		desc = "Switch Workspace",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>oq",
		func = "Obsidian quick_switch",
		desc = "Quick Switch Note",
		kind = "function",
	},
	{
		mode = "normal",
		key = "<leader>oo",
		func = "Obsidian open",
		desc = "Open Obsidian Vault",
		kind = "function",
	},
})

-- LSP Keymaps
join_keymaps("LSP", {
	{
		mode = "normal",
		key = "<F2>",
		func = vim.lsp.buf.rename,
		desc = "LSP Rename Symbol",
	},

	{
		mode = "normal",
		key = "gD",
		func = vim.lsp.buf.declaration,
		desc = "LSP Go to Declaration",
	},
	{
		mode = "normal",
		key = "gd",
		func = vim.lsp.buf.definition,
		desc = "LSP Go to Definition",
	},
	{
		mode = "normal",
		key = "gi",
		func = vim.lsp.buf.implementation,
		desc = "LSP Go to Implementation",
	},
	{
		mode = "normal",
		key = "gr",
		func = vim.lsp.buf.references,
		desc = "LSP Go to References",
	},
	{
		mode = "normal",
		key = "gl",
		func = vim.diagnostic.open_float,
		desc = "LSP Show Diagnostics",
	},

	{
		mode = "normal",
		key = "[",
		func = function()
			vim.diagnostic.jump({ count = -1, float = true })
		end,
		desc = "LSP Jump to Previous Diagnostic",
	},
	{
		mode = "normal",
		key = "]",
		func = function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
		desc = "LSP Jump to Next Diagnostic",
	},

	{
		mode = "normal",
		key = "K",
		func = vim.lsp.buf.hover,
		desc = "LSP Hover Documentation",
	},

	{
		mode = { "normal", "visual", "visual-block" },
		key = "<leader>la",
		func = vim.lsp.buf.code_action,
		desc = "LSP Code Action",
	},
	{
		mode = "normal",
		key = "<leader>ls",
		func = vim.lsp.buf.signature_help,
		desc = "LSP Signature Help",
	},
	{
		mode = "normal",
		key = "<leader>lt",
		func = vim.lsp.buf.type_definition,
		desc = "LSP Go to Type Definition",
	},
	{
		mode = "normal",
		key = "<leader>lh",
		func = function()
			vim.lsp.inlay_hint.enable(
				not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }),
				{ bufnr = vim.api.nvim_get_current_buf() }
			)
		end,
		desc = "Toggle LSP Inlay Hints",
	},
})
