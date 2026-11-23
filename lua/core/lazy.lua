local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"

	vim.fn.system({
		"git",
		"clone",
		lazyrepo,
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ dir = "/nvme/Projects/work/didcat/repos/meowy/editor/nvim" },
	},
	change_detection = {
		notify = false,
	},
})
