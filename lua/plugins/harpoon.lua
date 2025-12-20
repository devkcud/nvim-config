return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({
			settings = {
				save_on_toggle = true,
				save_on_change = true,
			},
		})

		local utils = require("core.keymaps.utils")

		utils.define_keymap("Harpoon", {
			mode = "normal",
			key = "<leader>ha",
			func = function()
				harpoon:list():add()
			end,
			desc = "Add File to Harpoon",
		})

		utils.define_keymap("Harpoon", {
			mode = "normal",
			key = "<leader>hh",
			func = function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Toggle Harpoon Quick Menu",
		})

		for i = 1, 9 do
			utils.define_keymap("Harpoon", {
				mode = "normal",
				key = "<leader>" .. i,
				func = function()
					harpoon:list():select(i)
				end,
				desc = "Go to Harpoon File " .. i,
			})
		end
	end,
}
