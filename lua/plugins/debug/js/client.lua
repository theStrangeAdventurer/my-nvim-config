local dap_keymaps = {
	{
		"<leader>db",
		function()
			require("dap").toggle_breakpoint()
		end,
		desc = "toggle [d]ebug [b]reakpoint",
	},
	{
		"<leader>dc",
		function()
			require("dap").continue()
		end,
		desc = "[d]ebug [c]ontinue (start here)",
	},
	{
		"<leader>do",
		function()
			require("dap").step_over()
		end,
		desc = "[d]ebug step [o]ver",
	},
	{
		"<leader>dO",
		function()
			require("dap").step_out()
		end,
		desc = "[d]ebug step [O]ut",
	},
	{
		"<leader>di",
		function()
			require("dap").step_into()
		end,
		desc = "[d]ebug [i]nto",
	},
	{
		"<leader>dl",
		function()
			require("dap").run_last()
		end,
		desc = "[d]ebug [l]ast",
	},
	{
		"<leader>dp",
		function()
			require("dap").pause()
		end,
		desc = "[d]ebug [p]ause",
	},
	{
		"<leader>dr",
		function()
			require("dap").repl.toggle()
		end,
		desc = "[d]ebug [r]epl",
	},
	{
		"<leader>dR",
		function()
			require("dap").clear_breakpoints()
		end,
		desc = "[d]ebug [R]emove breakpoints",
	},
	{
		"<leader>dt",
		function()
			require("dap").terminate()
		end,
		desc = "[d]ebug [t]erminate",
	},
}


local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

local dap_icons = {
	Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = { " ", "DiagnosticError" },
	LogPoint = ".>",
}

return {
	'mfussenegger/nvim-dap',
	keys = dap_keymaps,
	event = 'VeryLazy',
	dependencies = {
		"mason-org/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				-- Update this to ensure that you have the debuggers for the langs you want
			},
		},
	},
	config = function()
		-- Set nice color highlighting at the stopped line
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

		local debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"
		-- Show nice icons in gutter instead of the default characters
		for name, sign in pairs(dap_icons) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define("Dap" .. name, {
				text = sign[1],
				texthl = sign[2] or "DiagnosticInfo",
				linehl = sign[3],
				numhl = sign[3],
			})
		end

		local dap = require("dap")

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { debugger_path .. "/out/src/dapDebugServer.js", "${port}" },
			}
		}
		for _, language in ipairs(js_based_languages) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = function()
						local utils = require 'dap.utils'
						return utils.pick_process({ filter = "node" })
					end,
					skipFiles = { "<node_internals>/**" },
					cwd = "${workspaceFolder}",
				}
			}
		end
	end
}
