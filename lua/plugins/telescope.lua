return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		vim.keymap.set("n", "<leader>ff", function()
			vim.cmd('Telescope live_grep')
		end, { desc = "[C]close current buffer" })
	end
}
