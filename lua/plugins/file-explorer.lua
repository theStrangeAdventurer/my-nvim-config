-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	config = function()
		vim.keymap.set('n', '<leader>b', '<cmd>Neotree float buffers<CR>')
		-- If you want icons for diagnostic errors, you'll need to define them somewhere:
		vim.fn.sign_define("DiagnosticSignError",
			{ text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn",
			{ text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo",
			{ text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint",
			{ text = "󰌵", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = false,
			use_libuv_file_watcher = true,
			filesystem = {
				follow_current_file = {
					enabled = true,
				}
			},
			window = {
				position = 'left',
				width = 30,
				mappings = {
					-- keep / for a regular vim search https://www.reddit.com/r/neovim/comments/181ajkb/mastering_neotree/
					["/"] = "noop",
					["l"] = "open",
					["h"] = "toggle_node",
					["P"] = {
						"toggle_preview",
						config = {
							use_float = false,
							use_image_nvim = false,
							-- title = 'Neo-tree Preview',
						},
					},
				}
			}
		})
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle files" }
	}
}
