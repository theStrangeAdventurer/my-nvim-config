return {
	cmd = { 'vscode-css-language-server', '--stdio' },
	filetypes = { "css", "scss", "less" },
	root_markers = { 'packages.json', '.git' },
	init_options = {
		provideFormatter = true
	},
	settings = {
		css = {
			validate = true
		},
		less = {
			validate = true
		},
		scss = {
			validate = true
		}
	}
}
