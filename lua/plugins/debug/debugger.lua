return {
	'microsoft/vscode-js-debug',
	version = "1.74.1",
	lazy = false,
	build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
}
