return {
	'ravitemer/mcphub.nvim',
	event = 'VeryLazy',
	dependencies = {
		'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
	},
	build = 'npm install -g mcp-hub@latest',
	config = function()
		-- Функция для чтения переменных из .zshenv
		local function load_zshenv()
			local zshenv_path = vim.fn.expand("~/.zshenv")
			if vim.fn.filereadable(zshenv_path) == 1 then
				local lines = vim.fn.readfile(zshenv_path)
				for _, line in ipairs(lines) do
					local key, value = line:match("^export%s+([^=]+)=(.+)$")
					if key and value then
						-- Убираем кавычки если есть
						value = value:gsub("^['\"](.+)['\"]$", "%1")
						vim.env[key] = value
					end
				end
			end
		end

		load_zshenv()
		require('mcphub').setup {
			config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path required
			-- Optional customization
			log = {
				level = vim.log.levels.WARN, -- DEBUG, INFO, WARN, ERROR
				to_file = true,  -- Creates ~/.local/state/nvim/mcphub.log
			},
			on_error = function(err)
				print(vim.inspect(err))
			end,
			on_ready = function()
				vim.notify("mcp hub is online!")
			end,
		}
	end,
}
