return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    opts = {
	window = {
		mappings = {
			["l"] = "open",
			["h"] = "toggle_node",
		}
	}
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
	{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle files" }
    }
}
