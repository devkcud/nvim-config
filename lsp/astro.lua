return {
    cmd = { "astro-ls", "stdio" },
    filetypes = { "astro" },
    root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
            "astro.config.mjs",
            "package.json",
            "pnpm-lock.yaml",
            "yarn.lock",
            "package-lock.json",
            ".git"
        )(fname)
    end,
}
