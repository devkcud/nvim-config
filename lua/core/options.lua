local options = {
	clipboard = "unnamedplus",
	mouse = "",

	showmode = false,
	smartindent = true,

	splitbelow = true,
	splitright = true,

	swapfile = false,
	undofile = true,

	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,

	cursorline = true,

	relativenumber = true,
	number = true,

	wrap = false,
	linebreak = true,

	scrolloff = 8,
	sidescrolloff = 8,

	fillchars = {
		eob = " ",
		fold = " ",
		foldopen = "",
		foldclose = "",
		foldsep = " ",
	},

	sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal",

	foldcolumn = "0",
	foldlevel = 99,
	foldlevelstart = 99,
	foldenable = true,

	showtabline = 2,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
