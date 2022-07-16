local M = {}

-- Credit: https://github.com/EdenEast/nightfox.nvim
local fmt = string.format
local is_windows = vim.startswith(vim.loop.os_uname().sysname, "Windows")

local function inspect(t)
	local list = {}
	for k, v in pairs(t) do
		local q = type(v) == "string" and [["]] or ""
		table.insert(list, fmt([[%s = %s%s%s]], k, q, v, q))
	end

	table.sort(list)
	return fmt([[{ %s }]], table.concat(list, ", "))
end

function M.compile()
	local theme = require("catppuccin.lib.mapper").apply()
	local lines = {
		[[
-- This file is autogenerated by CATPPUCCIN.
-- DO NOT make changes directly to this file.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "catppuccin"]],
	}
	local config = require("catppuccin.config").options
	if is_windows then
		config.compile.path = config.compile.path:gsub("/", "\\")
	end

	for property, value in pairs(theme.properties) do
		if type(value) == "string" then
			table.insert(lines, fmt('vim.o.%s = "%s"', property, value))
		elseif type(value) == "bool" then
			table.insert(lines, fmt("vim.o.%s = %s", property, value))
		elseif type(value) == "table" then
			table.insert(lines, fmt("vim.o.%s = %s", property, inspect(value)))
		end
	end
	local tbl = vim.tbl_deep_extend("keep", theme.integrations, theme.editor)
	tbl = vim.tbl_deep_extend("keep", theme.syntax, tbl)
	tbl = vim.tbl_deep_extend("keep", config.custom_highlights, tbl)

	for group, color in pairs(tbl) do
		if color.link then
			table.insert(lines, fmt([[vim.api.nvim_set_hl(0, "%s", { link = "%s" })]], group, color.link))
		else
			if color.style then
				if color.style ~= "NONE" then
					if type(color.style) == "table" then
						for _, style in ipairs(color.style) do
							color[style] = true
						end
					else
						color[color.style] = true
					end
				end
			end

			color.style = nil
			vim.api.nvim_set_hl(0, group, color)
			table.insert(lines, fmt([[vim.api.nvim_set_hl(0, "%s", %s)]], group, inspect(color)))
		end
	end

	if config.term_colors == true then
		for k, v in pairs(theme.terminal) do
			table.insert(lines, fmt('vim.g.%s = "%s"', k, v))
		end
	end
	os.execute(string.format("mkdir %s %s", is_windows and "" or "-p", config.compile.path))
	local file = io.open(
		config.compile.path
			.. (is_windows and "\\" or "/")
			.. vim.g.catppuccin_flavour
			.. config.compile.suffix
			.. ".lua",
		"w"
	)
	file:write(table.concat(lines, "\n"))
	file:close()
end

function M.clean()
	local config = require("catppuccin.config").options
	local compiled_path = config.compile.path
		.. (is_windows and "\\" or "/")
		.. vim.g.catppuccin_flavour
		.. config.compile.suffix
		.. ".lua"
	os.remove(compiled_path)
end

return M
