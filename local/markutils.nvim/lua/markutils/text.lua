local M = {}

--- Wrap the text with the given wrapper
---
---@param text string
---@param wrapper string
---@return string
local function wrap(text, wrapper)
	return wrapper .. text .. wrapper
end

--- Walk the tree-sitter node and extract text, removing certain formatting
---
--- @param node TSNode
--- @param bufnr number
--- @param strip table<string, boolean>
--- @return string
local function walk(node, bufnr, strip)
	local t = node:type()

	if strip[t] then
		local out = {}
		for child in node:iter_children() do
			table.insert(out, walk(child, bufnr, strip))
		end
		return table.concat(out)
	end

	if node:child_count() == 0 then
		return vim.treesitter.get_node_text(node, bufnr)
	end

	local out = {}
	for child in node:iter_children() do
		table.insert(out, walk(child, bufnr, strip))
	end

	return table.concat(out)
end

--- Remove existing wrappers from the text to avoid nested formatting
---
---@param text string
---@param wrapper string
---@return string
local function clean(text, wrapper)
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, vim.split(text, "\n"))

	local parser = vim.treesitter.get_parser(bufnr, "markdown")

	if not parser then
		vim.notify("Tree-sitter parser for markdown not found.", vim.log.levels.ERROR)
		vim.api.nvim_buf_delete(bufnr, { force = true })
		return text
	end

	local tree = parser:parse()[1]
	local root = tree:root()

	local strip = {}
	if wrapper == "*" then
		strip.emphasis = true
	elseif wrapper == "**" then
		strip.strong_emphasis = true
	end

	local result = walk(root, bufnr, strip)

	vim.api.nvim_buf_delete(bufnr, { force = true })

	return result
end

---@param text string
---@return string
function M.bold(text)
	local symbol = "**"
	return wrap(clean(text, symbol), symbol)
end

---@param text string
---@return string
function M.italic(text)
	local symbol = "*"
	return wrap(clean(text, symbol), symbol)
end

---@param text string
---@return string
function M.code(text)
	local symbol = "`"
	return wrap(clean(text, symbol), symbol)
end

---@param text string
---@return string
function M.strikethrough(text)
	local symbol = "~~"
	return wrap(clean(text, symbol), symbol)
end

---@param text string
---@return string
function M.list(text)
	-- TODO: Handle existing list items
	-- TODO: Handle nested lists
	-- TODO: Support ordered lists
	-- TODO: Account for indentation

	local lines = vim.split(text, "\n")
	for i, line in ipairs(lines) do
		lines[i] = "- " .. line
	end
	return table.concat(lines, "\n")
end

---@param text string
---@return string
function M.blockquote(text)
    -- NOTE: Should we account for indentation? Since blockquotes cannot be nested in markdown.

    -- TODO: Handle existing blockquotes
    -- TODO: Handle nested blockquotes

	local lines = vim.split(text, "\n")
	for i, line in ipairs(lines) do
		lines[i] = "> " .. line
	end
	return table.concat(lines, "\n")
end

return M
