local gradle = { "settings.gradle", "settings.gradle.kts", "gradlew" }
local builds = { "pom.xml", "build.gradle", "build.gradle.kts", "build.xml", ".project" }
local runtimes, server = require("utils.java").jdks()

return {
	root_dir = function(buf, attach)
		local file = vim.api.nvim_buf_get_name(buf)
		if file == "" or not vim.startswith(vim.uri_from_bufnr(buf), "file://") then
			return
		end

		local root = vim.fs.root(buf, { "mvnw", ".mvn", unpack(gradle) })
		if not root then
			local repo = vim.fs.root(buf, ".git")
			local reactor = repo and vim.uv.fs_stat(vim.fs.joinpath(repo, "pom.xml"))
			root = reactor and repo or vim.fs.root(buf, builds) or repo
		end
		attach(root or vim.fs.dirname(file))
	end,
	cmd = function(dispatchers, config)
		local root = config.root_dir
		local data = vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", vim.fn.sha256(root))
		local cmd = { "jdtls", "-data", data }
		if server then
			vim.list_extend(cmd, { "--java-executable", vim.fs.joinpath(server, "bin", "java") })
		end
		local lombok = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "share", "jdtls", "lombok.jar")
		if vim.fn.filereadable(lombok) == 1 then
			table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
		end
		config.cmd = cmd
		return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root, env = config.cmd_env, detached = config.detached })
	end,
	settings = {
		java = {
			configuration = { updateBuildConfiguration = "automatic", runtimes = runtimes },
			inlayHints = { parameterNames = { enabled = "literals" } },
		},
	},
	on_attach = function(client, buf)
		vim.keymap.set(
			"n",
			"<leader>jo",
			require("jdtls").organize_imports,
			{ buffer = buf, desc = "Java: Organize imports" }
		)

		local root = client.config.root_dir
		if vim.fs.root(root, { "build.gradle", "build.gradle.kts", unpack(gradle) }) == root then
			local wrapper = vim.fs.joinpath(root, "gradlew")
			local cmd = vim.fn.executable(wrapper) == 1 and vim.fn.shellescape(wrapper) or "gradle"
			vim.bo[buf].makeprg = cmd .. " --project-dir " .. vim.fn.shellescape(root)
		elseif vim.fn.filereadable(vim.fs.joinpath(root, "pom.xml")) == 1 then
			local wrapper = vim.fs.joinpath(root, "mvnw")
			local cmd = vim.fn.executable(wrapper) == 1 and vim.fn.shellescape(wrapper) or "mvn"
			vim.bo[buf].makeprg = cmd .. " -f " .. vim.fn.shellescape(vim.fs.joinpath(root, "pom.xml"))
		end
	end,
}
