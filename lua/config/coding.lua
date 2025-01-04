vim.g.local_settings = { root = vim.env.PWD, launch_json_path = nil }

local function trim(value)
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local DEFAULT_ROOT_MARKER = "tsconfig.json,.git"
-- Define the function to be executed
local function setLocalSettings(t)
	setmetatable(t, { __index = { buf = 0 } })
	local rootMarkers = vim.env.LSP_ROOT_MARKERS

	if (rootMarkers == nil) then
		rootMarkers = DEFAULT_ROOT_MARKER
	else
		rootMarkers = rootMarkers .. "," .. DEFAULT_ROOT_MARKER
	end
	local markers = {}
	for word in string.gmatch(rootMarkers, "([^,]+)") do
		markers[#markers + 1] = trim(word)
	end

	local rootDir = vim.fs.root(t.buf, markers)
	local launch_json_path = vim.fs.root(vim.env.PWD, ".vscode");
	if (launch_json_path ~= nil) then
		launch_json_path = launch_json_path .. "/.vscode/launch.json"
	end
	if (rootDir) then
		vim.g.local_settings = {
			root = rootDir,
			root_markers = markers,
			launch_json_path = launch_json_path
		}
	end
end

vim.api.nvim_create_autocmd('BufReadPost', {
	desc = 'set coding settings every time when opening buffer',
	callback = function(ev)
		setLocalSettings(ev)
	end
})

setLocalSettings({}) -- initial setttings
return {}
