local ui = require("utils.ui")

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lua",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "snippets" } })

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			completion = {
				autocomplete = {},
				completeopt = "menu,menuone,noinsert",
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
						vim.api.nvim_feedkeys(vim.fn["copilot#Accept"]("\t"), "n", true)
					elseif luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local hl_group = "CmpItemKind" .. vim_item.kind

					vim_item.kind_hl_group = hl_group
					local kind_icon = ui.cmp.icons[vim_item.kind] or ""
					local kind_text = vim_item.kind or ""

					vim_item.kind = string.format(" %s ", kind_icon)
					vim_item.abbr = string.format(" %s", vim_item.abbr)

					local source_names = {
						nvim_lsp = string.format("󰒋 %s", kind_text),
						luasnip = "󰩫 Snippet",
						buffer = "󰦨 Buffer",
						path = "󰴠 Path",
						cmdline = " Cmd",
						nvim_lua = " Lua",
					}
					vim_item.menu = source_names[entry.source.name] or string.format("[%s]", entry.source.name)

					return vim_item
				end,
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
					col_offset = -3,
					side_padding = 0,
					border = ui.border,
					scrollbar = true,
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
					border = ui.border,
					max_width = 80,
					max_height = 20,
				}),
			},
			experimental = {
				ghost_text = {
					hl_group = "LspInlayHint",
				},
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "luasnip", max_item_count = 10, priority = 750 },
				{ name = "buffer", priority = 500, max_item_count = 10, keyword_length = 3 },
				{ name = "path", priority = 250, max_item_count = 5 },
				{ name = "nvim_lua", priority = 300 },
			}),
			performance = {
				debounce = 80,
				throttle = 40,
				fetching_timeout = 200,
				confirm_resolve_timeout = 80,
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}
