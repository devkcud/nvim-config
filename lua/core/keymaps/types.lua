---@alias Mode '"normal"'|'"insert"'|'"visual"'|'"visual-block"'|'"command"'|'"terminal"'

---@class Keymap
---@field mode Mode|Mode[]
---@field key string
---@field func string|function
---@field desc? string
---@field extra_opts? vim.keymap.set.Opts
