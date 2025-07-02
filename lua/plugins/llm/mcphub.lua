return {
	'ravitemer/mcphub.nvim',
	event = 'VeryLazy',
	dependencies = {
		'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
	},
	-- build = 'npm install -g mcp-hub@latest',
	build = "bundled_build.lua",
	config = function()
		require('mcphub').setup {
			use_bundled_binary = true,
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
