return {
	'microsoft/vscode-js-debug',
	version = "1.96.0",
	lazy = false,
	build = "npm install --legacy-peer-deps && npx gulp dapDebugServer && mv dist out"
}
