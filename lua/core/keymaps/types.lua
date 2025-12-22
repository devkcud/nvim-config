---@alias Mode '"normal"'|'"insert"'|'"visual"'|'"visual-block"'|'"command"'|'"terminal"'

---@class Keymap
---@field mode Mode|Mode[]
---@field key string
---@field kind? "normal"|"function" Defaults to "normal"
---@field func string|function
---@field desc? string
---@field cond? fun(): boolean
---@field extra_opts? vim.keymap.set.Opts
