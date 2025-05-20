local lsp_configs_dir = vim.fn.stdpath("config") .. "/lsp"

local handle = vim.loop.fs_scandir(lsp_configs_dir)
if not handle then
	vim.notify("Не удалось открыть директорию: " .. directory, vim.log.levels.ERROR)
	return
end

while true do
	local name, type = vim.loop.fs_scandir_next(handle)
	if not name then break end

	if type == "file" and name:match("%.lua$") then
		local parts = vim.split(name, '.', { plain = true });
		-- Загружаем конфигурацию из файла
		local config_path = lsp_configs_dir .. '/' .. name
		local config_status, config = pcall(dofile, config_path)
		local lsp_name = parts[1];

		if config_status and config then
			local patterns = vim.tbl_map(function(ext)
				return '*.' .. ext
			end, config.filetypes);
			vim.lsp.enable(lsp_name);
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = patterns,
				callback = function(ev)
					print(vim.inspect(ev))
					vim.lsp.start(vim.tbl_extend('force', config, {
						name = lsp_name,
						root_dir = vim.fs.root(ev.buf, config.root_markers or { 'package.json' })
					}))
				end,
			});
		else
			vim.notify("Ошибка при загрузке конфигурации LSP: " .. lsp_name, vim.log.levels.ERROR)
		end
	end
end

vim.diagnostic.config({
	virtual_text = { current_line = true }
});

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.json",
	callback = function()
		-- Сохраняем текущую позицию курсора
		local cursor_pos = vim.fn.getpos('.')

		-- Запускаем jq для форматирования всего буфера
		vim.cmd([[%!jq '.']])

		-- Если jq вернул ошибку (ненулевой код), отменяем изменения и показываем сообщение
		if vim.v.shell_error ~= 0 then
			vim.cmd('undo')
			vim.notify("jq не смог отформатировать JSON: возможно, JSON невалиден", vim.log.levels.ERROR)
		end

		-- Восстанавливаем позицию курсора
		vim.fn.setpos('.', cursor_pos)
	end,
	desc = "Format JSON files with jq before saving"
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		-- Go to definition
		if client:supports_method('textDocument/definition') then
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
				buffer = args.buf,
				desc = "Go to definition"
			})
		end

		-- Code action
		if client:supports_method('textDocument/codeAction') then
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {
				buffer = args.buf,
				desc = "Code action"
			})
			-- Также можно добавить для визуального режима
			vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, {
				buffer = args.buf,
				desc = "Code action (selection)"
			})
		end

		-- Go to implementation
		if client:supports_method('textDocument/implementation') then
			vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {
				buffer = args.buf,
				desc = "Go to implementation"
			})
		end
		-- Hover information (K)
		if client:supports_method('textDocument/hover') then
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
				buffer = args.buf,
				desc = "Show hover information"
			})
		end
		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
