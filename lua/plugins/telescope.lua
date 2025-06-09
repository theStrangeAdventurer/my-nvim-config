return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	lazy = true,
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', enabled = true } },
	config = function()
		require('telescope').setup {
			defaults = {
				vimgrep_arguments = {
					'rg',
					'--color=never',
					'--no-heading',
					'--with-filename',
					'--line-number',
					'--column',
					'--smart-case',
					'--hidden',
					'--glob=!pnpm-lock.yaml',
					'--glob=!dist/*',
					'--glob=!**/dist/*',
					'--glob=!.next/*',
					'--glob=!**/.next/*',
					'--glob=!build/*',
					'--glob=!**/build/*',
					'--glob=!node_modules/*',
					'--glob=!*.jpg',
					'--glob=!*.jpeg',
					'--glob=!*.png',
					'--glob=!*.svg',
					'--glob=!**/*.png',
					'--glob=!*.gif',
					'--glob=!*.bmp',
					'--glob=!*.svg',
					'--glob=!*.webp',
					'--glob=!*.ico',
					'--glob=!*.tiff',
					'--glob=!*.tif',
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,    -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			},
		}
		require('telescope').load_extension('fzf')
		vim.keymap.set("n", "<leader>fi", function()
			require("telescope.builtin").live_grep({ hidden = true })
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
	end
}
