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
	event = 'VeryLazy',
	dependencies = {
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
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
				-- Update this to ensure that you have the debuggers for the langs you want
			},
		},
	},
	config = function(_, opts)
		print(vim.inspect(opts))
		-- Set nice color highlighting at the stopped line
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

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
		if opts.configurations ~= nil then
			local merged = require("config.utils").deep_tbl_extend(dap.configurations, opts.configurations)
			dap.configurations = merged
		end
	end,
	keys = {
		{
			"<leader>db",
			function()
				-- if vim.fn.filereadable(vim.g.local_settings.launch_json_path) then
				-- 	local dap_vscode = require("dap.ext.vscode")
				-- 	dap_vscode.load_launchjs(nil, {
				-- 		["pwa-node"] = js_based_languages,
				-- 		["chrome"] = js_based_languages,
				-- 		["pwa-chrome"] = js_based_languages,
				-- 	})
				-- end
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
	},
}
