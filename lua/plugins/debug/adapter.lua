local debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"

return {
	'mxsdev/nvim-dap-vscode-js',

	dependencies = {
		"mfussenegger/nvim-dap",
		{
			"Joakker/lua-json5",
			build = "./install.sh",
		},
	},
	opts = {
		debugger_path = debugger_path,
		adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
	}
}
