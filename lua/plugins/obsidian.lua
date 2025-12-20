return {
	"obsidian-nvim/obsidian.nvim",
	opts = {
		ui = {
			enable = false,
		},
		workspaces = {
			{
				name = "all",
				path = "/nvme/Documents/obsidian/all",
				strict = true,
			},
			{
				name = "duckproblems",
				path = "/nvme/Documents/obsidian/duckproblems",
				strict = true,
			},
			{
				name = "Incube",
				path = "/nvme/Documents/obsidian/Incube",
				strict = true,
			},
			{
				name = "OpenSolace",
				path = "/nvme/Documents/obsidian/OpenSolace",
				strict = true,
			},
			{
				name = "religious-study",
				path = "/nvme/Documents/obsidian/religious-study",
				strict = true,
			},
			{
				name = "teach",
				path = "/nvme/Documents/obsidian/teach",
				strict = true,
			},
		},
		notes_subdir = "notes",
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = "daily.md",
		},
		completion = {
			nvim_cmp = true,
		},
		frontmatter = {
			enabled = false,
		},
		legacy_commands = false,
	},
}
