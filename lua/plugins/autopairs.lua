-- Configuration for nvim-autopairs plugin
-- Automatically closes pairs like brackets, quotes, etc.
-- Documentation: https://github.com/windwp/nvim-autopairs

return {
	-- Plugin repository
	'windwp/nvim-autopairs',

	-- Load the plugin on InsertEnter event
	event = 'InsertEnter',

	-- Optional dependency: nvim-cmp for better integration with autocompletion
	dependencies = { 'hrsh7th/nvim-cmp' },

	-- Configuration function for the plugin
	config = function()
		-- Initialize autopairs with default settings
		require('nvim-autopairs').setup({})

		-- Integrate with nvim-cmp for better autocompletion experience
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		local cmp = require('cmp')

		-- Automatically add closing pairs after selecting a function or method
		cmp.event:on(
			'confirm_done',
			cmp_autopairs.on_confirm_done()
		)
	end,
}
