local function get_ts_hl_at_pos(bufnr, row, col)
	local ok, captures = pcall(vim.treesitter.get_captures_at_pos, bufnr, row, col)
	if not ok or not captures then
		return nil
	end

	for i = #captures, 1, -1 do
		local hl = "@" .. captures[i].capture
		if vim.fn.hlID(hl) ~= 0 then
			return hl
		end
	end

	return nil
end

local function get_matching_closing(bufnr, lnum)
	local parser = vim.treesitter.get_parser(bufnr)
	if not parser then
		return nil, nil
	end

	local tree = parser:parse()[1]
	if not tree then
		return nil, nil
	end

	local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
	local col = math.max(#line - 1, 0)

	local root = tree:root()
	local node = root:named_descendant_for_range(lnum - 1, col, lnum - 1, col)

	while node do
		local child_count = node:child_count()
		if child_count >= 2 then
			local last_child = node:child(child_count - 1)
			if last_child then
				local text = vim.treesitter.get_node_text(last_child, bufnr)

				if text == "}" or text == "]" or text == ")" or text == "end" then
					local hl = get_ts_hl_at_pos(bufnr, last_child:start())
					return text, hl or "@punctuation.bracket"
				end
			end
		end

		node = node:parent()
	end

	return nil, nil
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		"nvim-treesitter/nvim-treesitter",
	},
	---@type UfoConfig
	opts = {
		fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
			local new_virt_text = {}

			local suffix = (" ... %d ... "):format(end_lnum - lnum)
			local suffix_width = vim.fn.strdisplaywidth(suffix)
			local target_width = width - suffix_width
			local cur_width = 0

			for _, chunk in ipairs(virt_text) do
				local chunk_text = chunk[1]
				local chunk_hl = chunk[2]
				local chunk_width = vim.fn.strdisplaywidth(chunk_text)

				if cur_width + chunk_width <= target_width then
					table.insert(new_virt_text, { chunk_text, chunk_hl })
					cur_width = cur_width + chunk_width
				else
					chunk_text = truncate(chunk_text, target_width - cur_width)
					table.insert(new_virt_text, { chunk_text, chunk_hl })
					break
				end
			end

			table.insert(new_virt_text, { suffix, "@number" })

			local closing_text, closing_hl = get_matching_closing(0, end_lnum)
			if closing_text then
				table.insert(new_virt_text, {
					" " .. closing_text,
					closing_hl or "@punctuation.bracket",
				})
			end

			return new_virt_text
		end,
		provider_selector = function(_, _, _)
			return { "treesitter", "indent" }
		end,
	},
}
