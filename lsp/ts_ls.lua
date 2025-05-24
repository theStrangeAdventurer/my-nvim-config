return {
	cmd = { 'typescript-language-server', '--stdio' },
	root_markers = { 'package.json' },
	custom_ext = { 'ts', 'tsx', 'js', 'jsx' }, -- custom field (see config/lsp-autocompletion.lua)
	filetypes = { 'ts', 'tsx', 'js', 'jsx', "javascript", "typescript", "typescriptreact", "javascriptreact", "typescript.tsx" },
}
