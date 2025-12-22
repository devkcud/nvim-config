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
	local condition = keymap.cond
	local kind = keymap.kind

	if not kind then
		if type(keymap.func) == "string" then
			kind = "normal"
		elseif type(keymap.func) == "function" then
			kind = "function"
		else
			error("keymap.func must be string or function")
		end
	end

	local opts = vim.tbl_extend("force", { noremap = true, silent = true }, keymap.extra_opts or {})

	if keymap.desc then
		opts.desc = category .. ": " .. keymap.desc
        if keymap.cond then
            opts.desc = opts.desc .. " [conditions apply]"
        end
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

	local fn

	if kind == "normal" then
		if type(keymap.func) ~= "string" then
			error("kind='normal' requires func to be a string")
		end
		if condition then
			error("cond is not supported for kind='normal'")
		end
		fn = keymap.func
	elseif kind == "function" then
		if type(keymap.func) == "function" then
			fn = keymap.func
		elseif type(keymap.func) == "string" then
			fn = function()
				vim.cmd(keymap.func)
			end
		else
			error("kind='function' requires func to be function or string")
		end

		if condition then
			local original = fn
			fn = function()
				if not condition() then
					return
				end
				return original()
			end
		end
	else
		error("Invalid keymap.kind: " .. tostring(kind))
	end

	for _, m in ipairs(modes) do
		vim.keymap.set(m, keymap.key, fn, opts)
	end
end

return M
