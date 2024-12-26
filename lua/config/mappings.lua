-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Save current buffer by pressint leader + w
vim.keymap.set("n", "<leader>c", function()
	local full_current_buffer_path = vim.fn.bufname('%') or ""
	local is_fs = string.find(full_current_buffer_path, 'filesystem') -- neo-tree filesystem
	local command = 'x'
	if is_fs then
		command = 'q'
	end

	local relative_buffer_path = vim.fn.fnamemodify(full_current_buffer_path, ':~:.')
	local message = "📁Buffer closed: " .. relative_buffer_path
	print(message)
	vim.cmd(command)

	vim.defer_fn(function()
		print(" ")
	end, 2000)
end, { desc = "[C]close current buffer" })

-- Save current buffer by pressing leader + w
vim.keymap.set("n", "<leader>w", function()
	if (vim.fn.filereadable(vim.fn.expand('%')) ~= 1) then return end
	vim.lsp.buf.format({ async = false })
	vim.cmd("w")
	print "📁Buffer saved ✨"
	vim.defer_fn(function()
		print(" ")
	end, 500)
end, { desc = "[W]rite (Save) current buffer" })

local function createTerminalBufferAndRunTerminal()
	-- Создание нового буфера
	local buf = vim.api.nvim_create_buf(false, true) -- buffer for temporal work
	vim.api.nvim_open_win(buf, false, {           -- https://neovim.io/doc/user/api.html#nvim_open_win()
		split = 'left',
		win = 0
	})
	-- Открытие терминала
	vim.api.nvim_command('terminal')
end

vim.keymap.set({ 'n', 't' }, '<leader>t', function()
	local commands = {
		n = "terminal",
		t = "q"
	}
	local command = commands[vim.fn.mode()]
	if command == nil then return end
	if command == commands.n then
		createTerminalBufferAndRunTerminal()
	else
		vim.cmd(command)
	end
end, {})
