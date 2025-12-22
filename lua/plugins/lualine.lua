local palette = require("utils.palette")

local function cord_presence_status()
	local manager = require("cord.server").manager

	if manager and (not manager.events_enabled or manager.is_paused or manager.is_force_idle) then
		return "󰙯 RPC off"
	end

	return "󰙯 RPC on" -- NOTE: This may be inaccurate if the presence hasn't been set yet
end

local function copilot_status()
	local copilot = vim.api.nvim_exec2("Copilot status", { output = true })

	local status = copilot.output
	if status:match("Disabled") then
		return "󰚩  Copilot off"
	else
		return "󰚩  Copilot on"
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"vyfor/cord.nvim",
		"github/copilot.vim",
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
			lualine_b = { "branch", { "filename", path = 0 }, "diff" },
			lualine_c = {},
			lualine_x = { copilot_status, cord_presence_status },
			lualine_y = { "location" },
			lualine_z = { "filetype" },
		},
	},
}
