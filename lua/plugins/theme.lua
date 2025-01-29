-- https://github.com/rebelot/kanagawa.nvim
return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup {
			transparent = true,
			-- theme = "lotus"
		}

		require("kanagawa").load "wave"
	end,
}
