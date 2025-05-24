return {
	"rcarriga/nvim-dap-ui",
	lazy = true,
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'

		-- Eval any user input while debugging
		vim.keymap.set("n", "<leader>dx", function()
			dapui.eval(vim.fn.input 'Expression: ')
		end, { desc = "Eval any user expression while debugging" })

		-- Eval input under the cursor
		vim.keymap.set("n", "<leader>de", function()
			dapui.eval(nil, { enter = true })
		end, { desc = "Eval expression under cursor while debugging" })

		-- Show floating dap window
		vim.keymap.set("n", "<leader>dh", function()
			require("dap.ui.widgets").hover()
		end, { desc = "Show debug infomation in floating window" })
		-- Close floating dap window by pressing q
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dap-float",
			callback = function()
				vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
			end
		})
		vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle debug [u]i ' })

		dapui.setup {
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
			controls = {
				icons = {
					pause = '⏸',
					play = '▶',
					step_into = '⏎',
					step_over = '⏭',
					step_out = '⏮',
					step_back = 'b',
					run_last = '▶▶',
					terminate = '⏹',
					disconnect = '⏏',
				},
			},
		}
		require "nvim-dap-virtual-text".setup {}
	end,
	dependencies = {
		"mfussenegger/nvim-dap",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio", }
}
