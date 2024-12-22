--[[ 		vim.fs.root(0, function(name, path)
			print("name >> " .. name)
			print("path >> " .. path);
			return false
		end)
 ]]

vim.g.local_settings = { root = vim.env.PWD }

local function trim(value)
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local DEFAULT_ROOT_MARKER = ".git"
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
	if (rootDir) then
		print("Set root dir: ")
		vim.g.local_settings = { root = rootDir, root_markers = rootMarkers }
				print(vim.inspect(vim.g.local_settings))
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
