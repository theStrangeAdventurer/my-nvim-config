return {
	cmd = { 'vscode-json-languageserver', '--stdio' },
	root_markers = { 'package.json' },
	filetypes = { 'json' },
	-- Добавьте эти строки для явного включения форматирования
	capabilities = {
		documentFormattingProvider = true,
		documentRangeFormattingProvider = true
	},
	-- Или используйте on_attach для включения форматирования
	on_attach = function(client, bufnr)
		print("Hello from json attach")
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
	end,
	settings = {
		json = {
			format = {
				enable = true
			},
			validate = { enable = true }
		},

	}
}
