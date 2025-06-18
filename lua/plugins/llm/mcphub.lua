return {
	'ravitemer/mcphub.nvim',
	event = 'VeryLazy',
	dependencies = {
		'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
	},
	build = 'npm install -g mcp-hub@latest',
	config = function()
		require('mcphub').setup {
			config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path required
			-- Optional customization
			log = {
				level = vim.log.levels.ERROR, -- DEBUG, INFO, WARN, ERROR
				to_file = true,   -- Creates ~/.local/state/nvim/mcphub.log
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
