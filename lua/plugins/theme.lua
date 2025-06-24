return {
	-- "sainnhe/everforest",
	"EdenEast/nightfox.nvim",
	lazy = false,
	config = function()
		require("nightfox").setup {
			options = {
				transparent = true,
			}
		}
		vim.cmd("colorscheme carbonfox")
	end
	-- https://github.com/rebelot/kanagawa.nvim
	-- "rebelot/kanagawa.nvim",
	-- config = function()
	-- 	require("kanagawa").setup {
	-- 		transparent = false,
	-- 		-- theme = "lotus"
	-- 	}
	--
	-- 	require("kanagawa").load "wave"
	-- end,
}
