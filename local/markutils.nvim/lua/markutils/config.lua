---@class MarkutilsConfig
local default_config = {}

local M = {
	---@type MarkutilsConfig
	config = {},
}

---@param config MarkutilsConfig?
function M.setup(config)
	vim.tbl_deep_extend("force", M.config, default_config, config or {})
end

return M
