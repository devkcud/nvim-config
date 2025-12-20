local ui = require("utils.ui")
local palette = require("utils.palette")

local colored_groups = {
	EndOfBuffer = { fg = palette.dark_gray },

	Normal = { fg = palette.white },
	Visual = { bg = palette.dark_gray },
	CursorLine = { fg = palette.none },
	CursorLineNr = { fg = palette.yellow },
	LineNr = { fg = palette.medium_gray },
	WinSeparator = { fg = palette.dark_gray },

	GitSignsAdd = { fg = palette.green },
	GitSignsDelete = { fg = palette.red },
	GitSignsChange = { fg = palette.cyan },
	GitSignsCurrentLineBlame = { fg = palette.medium_gray, italic = true },

	Statement = { fg = palette.dark_blue },
	Delimiter = { fg = palette.light_gray },
	Operator = { fg = palette.cyan },
	Comment = { fg = palette.medium_gray, italic = true },
	String = { fg = palette.green },
	Special = { fg = palette.cyan },
	Function = { fg = palette.blue },
	Identifier = { fg = palette.light_gray },
	Keyword = { fg = palette.purple },
	Type = { fg = palette.dark_blue },

	Pmenu = { fg = palette.light_gray },
	PmenuSel = { fg = palette.cyan },
	PmenuSbar = { fg = palette.dark_gray },
	PmenuThumb = { fg = palette.medium_gray },

	CmpNormal = { fg = palette.light_gray },
	CmpDocNormal = { fg = palette.light_gray },
	CmpBorder = { fg = palette.medium_gray },
	CmpDocBorder = { fg = palette.medium_gray },
	CmpItemKindDefault = { fg = palette.light_gray },
	CmpItemMenu = { fg = palette.medium_gray },
	CmpItemAbbrMatch = { fg = palette.cyan },
	CmpItemAbbrMatchFuzzy = { fg = palette.blue },

	FloatBorder = { fg = palette.medium_gray },
	FloatTitle = { fg = palette.cyan },

	TelescopeSelection = { fg = palette.cyan },
	TelescopeSelectionCaret = { fg = palette.cyan },
	TelescopeMatching = { fg = palette.blue },
	TelescopePromptPrefix = { fg = palette.cyan },
	TelescopePromptCounter = { fg = palette.medium_gray },
	TelescopeTitle = { fg = palette.cyan },

	["@type"] = { fg = palette.purple },
	["@type.builtin"] = { fg = palette.purple },
	["@function"] = { fg = palette.blue },
	["@function.builtin"] = { fg = palette.cyan },
	["@function.call"] = { fg = palette.blue },
	["@method"] = { fg = palette.blue },
	["@method.call"] = { fg = palette.blue },
	["@constructor"] = { fg = palette.yellow },
	["@module"] = { fg = palette.blue },
	["@namespace"] = { fg = palette.cyan },

	["@comment.documentation"] = { fg = palette.yellow },

	["@variable"] = { fg = palette.white },
	["@variable.builtin"] = { fg = palette.red },
	["@variable.parameter"] = { fg = palette.white },
	["@variable.member"] = { fg = palette.light_gray },
	["@constant"] = { fg = palette.yellow },
	["@constant.builtin"] = { fg = palette.yellow },

	["@string"] = { fg = palette.green },
	["@string.escape"] = { fg = palette.purple },
	["@string.regexp"] = { fg = palette.dark_blue },
	["@number"] = { fg = palette.yellow },
	["@boolean"] = { fg = palette.yellow },

	["@keyword"] = { fg = palette.purple },
	["@keyword.function"] = { fg = palette.purple },
	["@keyword.operator"] = { fg = palette.purple },
	["@keyword.return"] = { fg = palette.purple },
	["@keyword.conditional"] = { fg = palette.purple },
	["@keyword.repeat"] = { fg = palette.purple },

	["@operator"] = { fg = palette.cyan },
	["@punctuation.delimiter"] = { fg = palette.light_gray },
	["@punctuation.bracket"] = { fg = palette.light_gray },
	["@punctuation.special"] = { fg = palette.cyan },

	["@markup.heading"] = { fg = palette.white },
	["@markup.link"] = { fg = palette.cyan },
	["@markup.link.label"] = { fg = palette.blue },
	["@markup.link.url"] = { fg = palette.cyan, underline = true },
	["@markup.raw"] = { fg = palette.green },
	["@markup.list"] = { fg = palette.cyan },
	["@markup.strong"] = { bold = true },
	["@markup.italic"] = { italic = true },
	["@markup.link.markdown_inline"] = { fg = palette.light_gray },
	["@markup.link.markdown_reference"] = { fg = palette.light_gray },

	["@tag"] = { fg = palette.green },
	["@tag.attribute"] = { fg = palette.yellow },
	["@tag.delimiter"] = { fg = palette.purple },

	["@property"] = { fg = palette.blue },
	["@attribute"] = { fg = palette.cyan },
	["@attribute.value"] = { fg = palette.yellow },

	Directory = { fg = palette.blue },
	NeoTreeGitIgnored = { fg = palette.medium_gray },
	NeoTreeGitModified = { fg = palette.yellow },
	NeoTreeGitUntracked = { fg = palette.green },
	NeoTreeGitAdded = { fg = palette.green },
	NeoTreeGitDeleted = { fg = palette.red },
	NeoTreeGitConflict = { fg = palette.red },
	NeoTreeGitRenamed = { fg = palette.cyan },
	NeoTreeDotFile = { fg = palette.medium_gray },
	NeoTreeFileName = { fg = palette.light_gray },
	NeoTreeFileNameOpened = { fg = palette.cyan },
	NeoTreeIndentMarker = { fg = palette.dark_gray },
	NeoTreeExpander = { fg = palette.medium_gray },
	NeoTreeRootName = { fg = palette.blue },

	WhichKey = { fg = palette.cyan },
	WhichKeyGroup = { fg = palette.blue },
	WhichKeyDesc = { fg = palette.light_gray },
	WhichKeySeparator = { fg = palette.medium_gray },
	WhichKeyBorder = { fg = palette.medium_gray },

	NotifyERRORBorder = { fg = palette.red },
	NotifyWARNBorder = { fg = palette.yellow },
	NotifyINFOBorder = { fg = palette.green },
	NotifyDEBUGBorder = { fg = palette.medium_gray },
	NotifyTRACEBorder = { fg = palette.purple },

	DiagnosticVirtualTextError = { fg = palette.red, italic = true },
	DiagnosticVirtualTextWarn = { fg = palette.yellow, italic = true },
	DiagnosticVirtualTextInfo = { fg = palette.cyan, italic = true },
	DiagnosticVirtualTextHint = { fg = palette.medium_gray, italic = true },
	DiagnosticSignError = { fg = palette.red },
	DiagnosticSignWarn = { fg = palette.yellow },
	DiagnosticSignInfo = { fg = palette.cyan },
	DiagnosticSignHint = { fg = palette.medium_gray },
	LspInlayHint = { fg = palette.medium_gray, italic = true },
}

for group, opts in pairs(colored_groups) do
	vim.api.nvim_set_hl(0, group, opts)
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts.border = vim.tbl_map(function(char)
		return { char, "FloatBorder" }
	end, ui.border)

	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
