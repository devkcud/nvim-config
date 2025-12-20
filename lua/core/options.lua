local options = {
	clipboard = "unnamedplus",
	mouse = "",

	showmode = false,
	smartindent = true,

	splitbelow = true,
	splitright = true,

	swapfile = false,

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
	},

	sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
