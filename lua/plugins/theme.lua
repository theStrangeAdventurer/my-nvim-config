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

-- OTHER COOL THEMES:
-- https://github.com/rmehri01/onenord.nvim
-- return {
-- 	"rmehri01/onenord.nvim",
-- 	opts = {
-- 		theme = 'dark',
-- 		borders = true,
-- 		-- disable = { background = true },
-- 		fade_nc = true
-- 	}
-- }

-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	config = function()
-- 		vim.cmd("colorscheme rose-pine")
-- 	end
-- }
