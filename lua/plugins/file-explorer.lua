return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    config = function() 
	print "hi from neo tree"
	vim.keymap.set('n', '<leader>b', '<cmd>Neotree float buffers<CR>')

	require("neo-tree").setup({
 		window = {
			mappings = {
				["l"] = "open",
				["h"] = "toggle_node",
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
