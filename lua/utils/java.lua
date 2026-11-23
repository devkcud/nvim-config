local M = {}

function M.jdks()
	local javac = vim.uv.fs_realpath(vim.fn.exepath("javac"))
	local default = vim.env.JAVA_HOME or (javac and vim.fs.dirname(vim.fs.dirname(javac)))
	local paths = vim.fn.glob("/usr/lib/jvm/*", false, true)
	local gradle = vim.env.GRADLE_USER_HOME or vim.fs.joinpath(vim.fn.expand("~"), ".gradle")
	vim.list_extend(paths, vim.fn.globpath(gradle, "jdks/*", false, true))
	if default then
		table.insert(paths, 1, default)
	end

	local runtimes, seen = {}, {}
	local server, major
	for _, path in ipairs(paths) do
		local release = vim.fs.joinpath(path, "release")
		if vim.fn.filereadable(release) == 1 and vim.fn.executable(vim.fs.joinpath(path, "bin", "javac")) == 1 then
			local version = table.concat(vim.fn.readfile(release), "\n"):match('JAVA_VERSION="([^"]+)"')
			local n = version and tonumber(version:match("^1%.(%d+)") or version:match("^%d+"))
			if n and not seen[n] then
				seen[n] = true
				local name = n <= 8 and "JavaSE-1." .. n or "JavaSE-" .. n
				table.insert(runtimes, { name = name, path = path, default = path == default })
				if n >= 25 and (not major or n < major) then
					server, major = path, n
				end
			end
		end
	end
	return runtimes, server
end

return M
