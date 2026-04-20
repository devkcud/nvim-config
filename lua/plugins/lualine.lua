local palette = require("utils.palette")

local function cord_presence_status()
	local manager = require("cord.server").manager

	if manager and (not manager.events_enabled or manager.is_paused or manager.is_force_idle) then
		return "󰙯 RPC off"
	end

	return "󰙯 RPC on" -- NOTE: This may be inaccurate if the presence hasn't been set yet
end

local function in_visual_mode()
	local mode = vim.fn.mode()

	return mode == "v" or mode == "V" or mode == "\22"
end

local function visual_selection_size()
	if not in_visual_mode() then
		return ""
	end

	local mode = vim.fn.mode()
	local wordcount = vim.fn.wordcount()
	local selected_chars = wordcount.visual_chars or wordcount.visual_bytes or 0
	local selection_start = vim.fn.getpos("v")[2]
	local cursor_line = vim.fn.getpos(".")[2]
	local selected_lines = math.abs(cursor_line - selection_start) + 1

	if mode == "V" then
		return string.format("%dL", selected_lines)
	end

	if selected_lines > 1 then
		return string.format("%dL %dC", selected_lines, selected_chars)
	end

	return string.format("%dC", selected_chars)
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"vyfor/cord.nvim",
	},
	opts = {
		options = {
			icons_enabled = true,
			theme = {
				normal = {
					a = { fg = palette.blue, bg = palette.none },
					b = { fg = palette.light_gray, bg = palette.none },
					c = { fg = palette.medium_gray, bg = palette.none },
				},
				insert = {
					a = { fg = palette.green, bg = palette.none },
				},
				visual = {
					a = { fg = palette.purple, bg = palette.none },
				},
				replace = {
					a = { fg = palette.red, bg = palette.none },
				},
				command = {
					a = { fg = palette.yellow, bg = palette.none },
				},
				inactive = {
					a = { fg = palette.medium_gray, bg = palette.none },
					b = { fg = palette.medium_gray, bg = palette.none },
					c = { fg = palette.medium_gray, bg = palette.none },
				},
			},
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = { "alpha", "neo-tree" } },
			always_divide_middle = true,
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", { "filename", path = 1 }, "diff" },
			lualine_c = {},
			lualine_x = {
				{
					visual_selection_size,
					cond = in_visual_mode,
				},
			},
			lualine_y = { "diagnostics", "location" },
			lualine_z = { "filetype" },
		},
	},
}
