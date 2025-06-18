return {
	-- "sainnhe/everforest",
	"EdenEast/nightfox.nvim",
	lazy = false,
	config = function()
		vim.cmd("colorscheme nightfox")
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
