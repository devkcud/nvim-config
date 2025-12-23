local function get_ts_hl_at_pos(bufnr, row, col)
	local ok, captures = pcall(vim.treesitter.get_captures_at_pos, bufnr, row, col)
	if not ok or not captures or #captures == 0 then
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

local function build_highlighted_line(bufnr, lnum)
	local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
	if not line or line == "" then
		return {}
	end

	local chunks = {}
	local current_hl = nil
	local current_text = ""

	for col = 0, #line - 1 do
		local char = line:sub(col + 1, col + 1)
		local hl = get_ts_hl_at_pos(bufnr, lnum - 1, col)

		if hl == current_hl then
			current_text = current_text .. char
		else
			if current_text ~= "" then
				table.insert(chunks, { current_text, current_hl })
			end
			current_hl = hl
			current_text = char
		end
	end

	if current_text ~= "" then
		table.insert(chunks, { current_text, current_hl })
	end

	return chunks
end

local function get_closing_chunks(bufnr, end_lnum)
	local line = vim.api.nvim_buf_get_lines(bufnr, end_lnum - 1, end_lnum, false)[1]
	if not line then
		return nil
	end

	local trimmed = line:match("^%s*(.-)%s*$")
	if not trimmed or trimmed == "" then
		return nil
	end

	local chunks = {}
	local keywords = { "endfunction", "endfor", "endwhile", "endtry", "endif", "end", "done", "esac", "fi" }

	for _, kw in ipairs(keywords) do
		if trimmed:sub(1, #kw) == kw then
			local after = trimmed:sub(#kw + 1)
			local rest = after:gsub("^[%}%]%)]+", ""):gsub("^%b()", ""):gsub("^[,;]", ""):gsub("^%s+$", "")

			if rest == "" then
				local leading_ws = #(line:match("^%s*") or "")
				local col = leading_ws

				local hl = get_ts_hl_at_pos(bufnr, end_lnum - 1, col)
				table.insert(chunks, { kw, hl or "@keyword" })
				col = col + #kw

				local closing = after:match("^([%}%]%)]+)")
				if closing then
					for i = 1, #closing do
						local char = closing:sub(i, i)
						local char_hl = get_ts_hl_at_pos(bufnr, end_lnum - 1, col)
						table.insert(chunks, { char, char_hl or "@punctuation.bracket" })
						col = col + 1
					end
					after = after:sub(#closing + 1)
				end

				if after:match("^%b()") then
					table.insert(chunks, { "()", "@punctuation.bracket" })
					after = after:gsub("^%b()", "")
				end

				local trailing = after:match("^([,;])")
				if trailing then
					local trailing_hl = get_ts_hl_at_pos(bufnr, end_lnum - 1, col)
					table.insert(chunks, { trailing, trailing_hl or "@punctuation.delimiter" })
				end

				return chunks
			end
		end
	end

	local brackets, trailing = trimmed:match("^([%}%]%)]+)([,;]?)$")
	if brackets then
		local leading_ws = #(line:match("^%s*") or "")
		local bracket_idx = trimmed:find("[%}%]%)]")
		if bracket_idx then
			local base_col = leading_ws + bracket_idx - 1
			for i = 1, #brackets do
				local char = brackets:sub(i, i)
				local col = base_col + i - 1
				local hl = get_ts_hl_at_pos(bufnr, end_lnum - 1, col)
				table.insert(chunks, { char, hl or "@punctuation.bracket" })
			end

			if trailing and trailing ~= "" then
				local trailing_col = base_col + #brackets
				local trailing_hl = get_ts_hl_at_pos(bufnr, end_lnum - 1, trailing_col)
				table.insert(chunks, { trailing, trailing_hl or "@punctuation.delimiter" })
			end
		end

		return chunks
	end

	return nil
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		"nvim-treesitter/nvim-treesitter",
	},
	---@type UfoConfig
	opts = {
		fold_virt_text_handler = function(_, lnum, end_lnum, width, truncate)
			local bufnr = vim.api.nvim_get_current_buf()
			local highlighted_chunks = build_highlighted_line(bufnr, lnum)
			local closing_chunks = get_closing_chunks(bufnr, end_lnum)

			local fold_count = closing_chunks and (end_lnum - lnum - 1) or (end_lnum - lnum)
			local suffix = (" 󰘖 %d "):format(fold_count)
			local suffix_width = vim.fn.strdisplaywidth(suffix)
			local target_width = width - suffix_width
			local cur_width = 0

			local new_virt_text = {}

			for _, chunk in ipairs(highlighted_chunks) do
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

			table.insert(new_virt_text, { suffix, "@punctuation.special" })

			if closing_chunks then
				for _, chunk in ipairs(closing_chunks) do
					table.insert(new_virt_text, chunk)
				end
			end

			return new_virt_text
		end,
		provider_selector = function(_, _, _)
			return { "treesitter", "indent" }
		end,
	},
}
