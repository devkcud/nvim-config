local M = {}

local function is_executable(path)
	return path ~= nil and path ~= "" and vim.fn.executable(path) == 1
end

local function mason_path(...)
	return vim.fs.joinpath(vim.fn.stdpath("data"), "mason", ...)
end

local function dedupe(items)
	local seen = {}
	local result = {}

	for _, item in ipairs(items) do
		if item ~= nil and item ~= "" and not seen[item] then
			seen[item] = true
			table.insert(result, item)
		end
	end

	return result
end

function M.tool_path(tool)
	local mason_bin = mason_path("bin", tool)
	if is_executable(mason_bin) then
		return mason_bin
	end

	if is_executable(tool) then
		return tool
	end

	return nil
end

function M.roslyn_available()
	return M.tool_path("roslyn") ~= nil
end

function M.netcoredbg_path()
	return M.tool_path("netcoredbg")
end

function M.find_debug_targets()
	local roots = dedupe({
		vim.fn.expand("%:p:h"),
		vim.fn.getcwd(),
	})

	local patterns = {
		"bin/Debug/**/*.dll",
		"bin/Release/**/*.dll",
	}

	local results = {}
	local seen = {}

	for _, root in ipairs(roots) do
		for _, pattern in ipairs(patterns) do
			for _, match in ipairs(vim.fn.globpath(root, pattern, true, true)) do
				local ignored = match:match("/ref/")
					or match:match("/obj/")
					or match:match("testhost")
					or match:match("dotnet%-watch")

				if not ignored and not seen[match] then
					seen[match] = true
					table.insert(results, match)
				end
			end
		end
	end

	table.sort(results)

	return results
end

function M.select_debug_target()
	local targets = M.find_debug_targets()
	local default_target = targets[1] or vim.fs.joinpath(vim.fn.getcwd(), "bin", "Debug")

	return vim.fn.input("Path to dll: ", default_target, "file")
end

return M
