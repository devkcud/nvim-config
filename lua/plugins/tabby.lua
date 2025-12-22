local palette = require("utils.palette")

return {
	"nanozuki/tabby.nvim",
	config = function()
		require("tabby.tabline").set(function(line)
			local tabby_theme = {
				fill = "Normal",
				head = { bg = palette.none, fg = palette.cyan },
				current_tab = { bg = palette.none, fg = palette.yellow, bold = true },
				tab = { bg = palette.none, fg = palette.medium_gray },
				win = { bg = palette.none, fg = palette.light_gray },
				tail = { bg = palette.none, fg = palette.cyan },
			}

			---@type TabbyElement
			return {
				{
					{ "  ", hl = tabby_theme.head },
					line.sep("   ", tabby_theme.fill, tabby_theme.fill),
				},
				line.tabs().foreach(function(tab)
					local hl = tab.is_current() and tabby_theme.current_tab or tabby_theme.tab

					---@type TabbyElement
					return {
						tab.is_current() and "➤" or " ",
						tab.name(),
						tab.close_btn(""),
						line.sep(" ", tabby_theme.fill, tabby_theme.fill),
						hl = hl,
						margin = " ",
					}
				end),
				line.spacer(),
				hl = tabby_theme.fill,
			}
		end)
	end,
}
