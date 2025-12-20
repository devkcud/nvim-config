local M = {}

---@param mode Mode
---@return string|nil
function M.mode_to_vim_mode(mode)
	local mode_map = {
		normal = "n",
		insert = "i",
		visual = "v",
		["visual-block"] = "x",
		command = "c",
		terminal = "t",
	}
	return mode_map[mode]
end

---@param category string
---@param keymap Keymap
function M.define_keymap(category, keymap)
	local opts = vim.tbl_extend("force", { noremap = true, silent = true }, keymap.extra_opts or {})

	if keymap.desc then
		opts.desc = category .. ": " .. keymap.desc
	end

	local modes = {}
	local mode_list = type(keymap.mode) == "table" and keymap.mode or { keymap.mode }

	for _, m in ipairs(mode_list) do
		local vim_mode = M.mode_to_vim_mode(m)
		if not vim_mode then
			error("Invalid mode: " .. tostring(m))
		end
		table.insert(modes, vim_mode)
	end

	for _, m in ipairs(modes) do
		vim.keymap.set(m, keymap.key, keymap.func, opts)
	end
end

return M
