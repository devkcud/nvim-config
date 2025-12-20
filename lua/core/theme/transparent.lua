local palette = require("utils.palette")

local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"NormalSB",
	"SignColumn",
	"EndOfBuffer",
	"TabLine",
	"TabLineFill",
	"TabLineSel",
	"StatusLine",
	"StatusLineNC",
	"TelescopeNormal",
	"TelescopeBorder",
	"NeoTreeNormal",
	"NeoTreeNormalNC",
	"WinBar",
	"WinBarNC",
	"Folded",
}

for _, group in ipairs(transparent_groups) do
	vim.api.nvim_set_hl(0, group, { bg = palette.none, ctermbg = palette.none })
end
