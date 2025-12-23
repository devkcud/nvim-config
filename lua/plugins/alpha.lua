return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		---@param text string
		---@return string[]
		local function split_lines(text)
			return vim.split(text, "\n", { trimempty = true })
		end

		dashboard.section.header.val = split_lines([[
                    ++++++++++++
                 ++++++++++++++++++
               ++++++++++++++++++++++
              ++++++++++++++++++++++++ + ++++
             ++++++++++++++++++++++++ +++ ++++++
             ++++++++++++++++++++++++++++++++++++
              ++++++++++++++++++++++++++++++++++++
              :::::::::,a@@a,:::::,a@a,++++++++++.
         .ooOOOOOOOOOOo@@@@@@oOoOo@@@@@,++++++++/:.
      o OOOOOOOOOOOOo@@@@@@@@@oOOo@@@@@@,++++++/:::
   o oOOOOOOOOOOOOOo@@@@@@@@@@@oOo@@@@@@a  ':::::::
  oOoOOOOOOOOOOOOOOo@@@@@@@@@@@oOo@@@@@@@   :::::::
 oOOOOOOOOOOOOOOOOo@@@@@@@@@@@@oOo@@@@@@@   ::: ::'
 oOOOOOOOOOOOOOOOOo`  '@@@@@@@@oOo` '@@@@  ,:'  '
 oOOOOOOO%%%%%OOOOo    @@@@@@@@oOo   @@@.
  oOOOO;%%%.%%%OOOo.  ,@@@@@@@oOOo. ,@@@'
   oOOO%%%.%%%%%OOOo.@@@@@@@@oOOOo@@@@@'
    OOO%%%.%%%%%%OOo@@@@@@@@oOOOOOo@@@'        .,;%%%%%;.
     OOO%%.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//%%%%%%%%%
       OO%%.%%%%%%%%%%%%%%%%;%%%%%%%%%%%%%%//%%%%%%%%%%%;
         O%%.....';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;'
           %%.............%%%%%%%%%%%%%%%%%%%%%%%;'
            %%............`%%,   """""""""""""
             %%............%%;
              %%...........%%;
               %%%%%%%%%%%%%;
                `%%%%%%%%%;']])

		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New file", ":new<CR>"),
			dashboard.button("p", "  > Open project", ":Telescope projects<CR>"),
			dashboard.button("E", "  > Open file explorer", ":Neotree<CR>"),
			dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("q", "  > Quit", ":qa!<CR>"),
		}

		alpha.setup(dashboard.opts)

		vim.cmd("autocmd FileType alpha setlocal nofoldenable")
	end,
}
