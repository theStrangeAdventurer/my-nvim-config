return {
	'akinsho/bufferline.nvim',
	version = "*",
	options = {
		indicator = {
			style = 'underline'
		},
		separator_style = "slant",
		show_buffer_icons = false
	},
	dependencies = 'nvim-tree/nvim-web-devicons',
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup {}
	end
}
