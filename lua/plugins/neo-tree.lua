local neo_tree_sources = {
	{ key = "filesystem", display = " Files" },
	{ key = "git_status", display = " Git" },
}

local sources = {}
local source_selector = {}

for _, item in ipairs(neo_tree_sources) do
	table.insert(sources, item.key)
	table.insert(source_selector, {
		source = item.key,
		display_name = item.display,
	})
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- Behaviour
		close_if_last_window = true,
		hide_root_node = true,
		enable_cursor_hijack = true,

		-- Style
		window = {
			position = "right",
		},
		popup_border_style = "rounded",
		default_component_configs = {
			indent = {
				indent_size = 4,
				padding = 2,
				indent_marker = "│",
				last_indent_marker = "│",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰜌",
				default = "*",
			},
			git_status = {
				added = "✚",
				modified = "",
				deleted = "✖",
				renamed = "󰁕",
				untracked = "",
				ignored = "",
				unstaged = "",
				staged = "",
				conflict = "",
			},
		},

		-- Sources
		default_source = "last",
		sources = sources,
		source_selector = {
			winbar = true,
			statusline = false,
			sources = source_selector,
			content_layout = "center",
			tabs_layout = "active",
		},
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfile = false,
				hide_gitignored = false,
				hide_hidden = false,
				never_show = {
					"node_modules",
				},
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			group_empty_dirs = false,
		},

		-- Events
		event_handlers = {
			{
				event = "file_opened",
				handler = function()
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
	},
}
