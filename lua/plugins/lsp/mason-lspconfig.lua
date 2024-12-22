-- https://github.com/williamboman/mason-lspconfig.nvim
return {
	"williamboman/mason-lspconfig",
	dependencies = { "mason.nvim" },
	config = function()
		local lspconfig = require("lspconfig")
		require("mason-lspconfig").setup({})

		require("mason-lspconfig").setup_handlers {
        		function (server_name) -- default handler (optional)
            			lspconfig[server_name].setup {}
        		end,
	        	-- Next, you can provide a dedicated handler for specific servers.
			["lua_ls"] = function ()
               			lspconfig.lua_ls.setup {
                   			settings = {
                       				Lua = {
                           				diagnostics = {
                               					globals = { "vim" }
                           				}
                       				}
                   			}
               			}
			end
		}
	end
}
