-- https://github.com/rebelot/kanagawa.nvim
return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup {
			transparent = false,
			-- theme = "lotus"
		}

		require("kanagawa").load "wave"
	end,
}
