-- https://github.com/williamboman/mason-lspconfig.nvim
return {
	"williamboman/mason-lspconfig",
	dependencies = { "mason.nvim" },
	config = function()
		local lspconfig = require("lspconfig")
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"jdtls",
				"ts_ls",
				"eslint",
			}
		})

		require("mason-lspconfig").setup_handlers {
			function(server_name) -- default handler (optional)
				lspconfig[server_name].setup {
				}
			end,
			-- Next, you can provide a dedicated handler for specific servers.
			["lua_ls"] = function()
				lspconfig.lua_ls.setup {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "jit" }
							}
						}
					}
				}
			end
		}

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }

				-- Jumps to the declaration of the symbol under the cursor.
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				-- Jumps to the definition of the symbol under the cursor.
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				-- Displays hover information about the symbol under the cursor in a floating
				-- window. Calling the function twice will jump into the floating window.
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- Lists all the implementations for the symbol under the cursor in the quickfix window.
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

				-- Displays signature information about the symbol under the cursor in a floating window.
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

				-- Jumps to the definition of the type of the symbol under the cursor.
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)

				-- Renames all references to the symbol under the cursor.
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

				-- Selects a code action available at the current cursor position.
				vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)

				-- Lists all the references to the symbol under the cursor in the quickfix window.
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

				-- Formats a buffer using the attached (and optionally filtered) language server clients.
				vim.keymap.set("n", "<space>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})
	end
}
