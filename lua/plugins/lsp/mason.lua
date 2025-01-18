-- https://github.com/williamboman/mason.nvim
return {
	"williamboman/mason.nvim",
	dependencies = {
		"nvim-lspconfig",
	},
	config = function()
		require "mason".setup({})
	end
}
