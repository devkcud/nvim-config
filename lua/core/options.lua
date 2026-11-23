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

	conceallevel = 0,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

local group = vim.api.nvim_create_augroup("NoConceal", { clear = true })

vim.api.nvim_create_autocmd("OptionSet", {
	group = group,
	pattern = "conceallevel",
	callback = function()
		if tonumber(vim.v.option_new) ~= 0 then
			vim.opt.conceallevel = 0
		end
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "SafeState" }, {
	group = group,
	callback = function()
		if vim.go.conceallevel ~= 0 then
			vim.go.conceallevel = 0
		end
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.wo[win].conceallevel ~= 0 then
				vim.wo[win].conceallevel = 0
			end
		end
	end,
})
