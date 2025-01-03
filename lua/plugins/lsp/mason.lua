-- https://github.com/williamboman/mason.nvim
return {
	"williamboman/mason.nvim",
	dependencies = {
		"nvim-lspconfig",
		-- "jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		require "mason".setup({})
		-- require("mason-nvim-dap").setup({
		-- 	ensure_installed = {
		-- 		"js-debug-adapter"
		-- 	}
		-- })
	end
}
