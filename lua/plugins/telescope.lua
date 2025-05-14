return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim', {
		-- https://github.com/princejoogie/dir-telescope.nvim
		"princejoogie/dir-telescope.nvim",
		opts = {
			hidden = true,
			no_ignore = true,
			show_preview = true,
			follow_symlinks = false,
		}
	} },
	config = function()
		require('telescope').setup { defaults = {
			file_ignore_patterns = { "pnpm-lock.yaml", "package-lock.json", "dist/", "build/", "node_modules", ".git" }
		} }
		vim.keymap.set("n", "<leader>fi", function()
			vim.cmd('Telescope live_grep')
		end, { desc = "Find [i]nside files" })
		-- Telescope find_files
		vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
			noremap = true,
			silent = true,
			desc = "Find [f]iles"
		})
		vim.keymap.set("n", "<leader>fd", "<cmd>Telescope dir live_grep<CR>", {
			noremap = true,
			silent = true,
			desc = "Find in [d]irectory"
		})
		vim.keymap.set("n", "<leader>fd", "<cmd>Telescope dir find_files<CR>", {
			noremap = true,
			silent = true,
			desc = "Find [d]irs"
		})
	end
}
