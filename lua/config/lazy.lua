-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Function to automatically discover plugin imports
local function get_plugin_imports()
	local imports = {}
	local config_path = vim.fn.stdpath("config")
	local plugins_path = config_path .. "/lua/plugins"

	-- Function to check if directory contains .lua files (recursively)
	local function has_lua_files(path)
		local handle = vim.uv.fs_scandir(path)
		if not handle then return false end

		while true do
			local name, type = vim.uv.fs_scandir_next(handle)
			if not name then break end

			if type == "file" and name:match("%.lua$") then
				return true
			end
		end
		return false
	end

	-- Include base plugins directory only if it has .lua files
	if has_lua_files(plugins_path) then
		table.insert(imports, { import = "plugins" })
	end

	-- Function to scan directory recursively
	local function scan_dir(path, base_import)
		local handle = vim.uv.fs_scandir(path)
		if not handle then return end

		while true do
			local name, type = vim.uv.fs_scandir_next(handle)
			if not name then break end

			if type == "directory" and not name:match("^%.") then
				local subdir_path = path .. "/" .. name
				local import_path = base_import .. "." .. name

				if has_lua_files(subdir_path) then
					table.insert(imports, { import = import_path })
				end
				scan_dir(subdir_path, import_path)
			end
		end
	end

	-- Scan the plugins directory
	scan_dir(plugins_path, "plugins")

	return imports
end
-- Setup lazy.nvim
require("lazy").setup({
	spec = get_plugin_imports(),
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	git = { timeout = 60 * 10 },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
