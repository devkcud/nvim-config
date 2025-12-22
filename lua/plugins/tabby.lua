math.randomseed(os.time())

local palette = require("utils.palette")

local theme = {
	tab_number = { fg = palette.purple },

	active_tab = { fg = palette.yellow, bold = true },
	inactive_tab = { fg = palette.medium_gray },

	modifier = { fg = palette.dark_blue },

	unsaved = { fg = palette.red },
}

local random_emoticon = (function()
	local icons = {
		" arch btw",
		"󰄛 cat ig",
		"ʕ•ᴥ•ʔ bear??",
		"༼ つ ◕_◕ ༽つ give code",
		"thon lol",
		" buggy",
		"󰇥 literal duck",
		" *ribbit*",
		" *squeak*",
		"󰓇 Currently playing: something... probably",
		"󰙯 0 new messages",
	}
	return icons[math.random(#icons)]
end)()

local spacer = string.rep(" ", 3)

return {
	"nanozuki/tabby.nvim",
	config = function()
		require("tabby.tabline").set(function(line)
			return {
				{
					{
						random_emoticon,
						hl = { fg = palette.dark_blue },
					},
					spacer,
				},
				line.tabs().foreach(function(tab)
					local hl = tab.is_current() and theme.active_tab or theme.inactive_tab
					local amount_hl = tab.is_current() and theme.modifier or theme.inactive_tab

					local win = tab.current_win()
					local name = win.buf_name():match("[^/]+$") or "Untitled"
					local modified = vim.bo[win.buf().id].modified and "*" or ""

					local tab_amount = #line.tabs().tabs
					local win_amount = #tab.wins().wins

					return {
						{
							tab.number() .. ": ",
							hl = theme.tab_number,
						},
						{
							name,
							hl = hl,
						},
						{
							modified,
							hl = theme.unsaved,
						},
						win_amount > 1 and {
							" +" .. (win_amount - 1),
							hl = amount_hl,
						},
						tab.number() ~= tab_amount and spacer,
					}
				end),
				line.spacer(),
			}
		end)
	end,
}
