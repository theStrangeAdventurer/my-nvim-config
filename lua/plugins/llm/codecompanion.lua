if (vim.env._LLM_DEFAULT_PLUGIN and vim.env._LLM_DEFAULT_PLUGIN ~= 'codecompanion') then
	return {}
end
print "codecompanion was loaded..."

local _default_adapter = 'ollama'
local adapters = {
	-- Посмотреть реализацию для ollama
	-- https://github.com/nhac43/dotfiles/blob/b3cce533551ea63d2d732ec38412dbee38d615ac/nvim/lua/codecompanion_config.lua#L4
	ollama = function()
		local openai = require("codecompanion.adapters.openai")
		return require("codecompanion.adapters").extend("openai_compatible", {
			schema = {
				model = {
					-- WIP
					-- default = "qwen2.5-coder:14b",
					default = "mistral:latest",
					-- default = "gemma3:12b",
				},
			},
			env = {
				chat_url = "/v1/chat/completions", -- optional: default value, override if different
			},
			-- https://github.com/olimorris/codecompanion.nvim/discussions/691
			handlers = {
				chat_output = function(self, data)
					local result = openai.handlers.chat_output(self, data)
					if result and result.output then
						result.output.role = "assistant"
					end
					return result
				end,
			},
		})
	end,
	deepseek = function()
		return require("codecompanion.adapters").extend("deepseek", {
			env = {
				api_key = vim.env.DEEPSEEK_API_KEY,
			},
			schema = {
				model = {
					default = "deepseek-chat",
				},
			},
		})
	end,
	anthropic = function()
		return require("codecompanion.adapters").extend("anthropic", {
			env = {
				api_key = vim.env.ANTHROPIC_API_KEY,
			},
		})
	end,
	custom_deepseek = vim.env.CUSTOM_DEEPSEEK_URL and function()
		return require("codecompanion.adapters").extend("openai_compatible", {
			env = {
				url = vim.env.CUSTOM_DEEPSEEK_URL,
				api_key = vim.env.CUSTOM_DEEPSEEK_TOKEN,
				chat_url = "/v1/chat/completions",
			},
			schema = {
				model = {
					default = "communal-deepseek-v3-0324-in-yt",
				},
			},
		})
	end or nil,
	custom_anthropic = vim.env.CUSTOM_ANTHROPIC_URL and function()
		return require("codecompanion.adapters").extend("anthropic", {
			url = vim.env.CUSTOM_ANTHROPIC_URL,
			env = {
				api_key = vim.env.CUSTOM_ANTHROPIC_TOKEN,
			},
		})
	end or nil
}
local default_adapter
if vim.env._LLM_DEFAULT_STRATEGY then
	default_adapter = vim.env._LLM_DEFAULT_STRATEGY
elseif adapters and adapters.custom_anthropic then
	default_adapter = 'custom_anthropic'
elseif adapters and adapters.deepseek and vim.env.DEEPSEEK_API_KEY then
	default_adapter = 'deepseek'
else
	default_adapter = _default_adapter
end

return {
	'olimorris/codecompanion.nvim',
	extensions = {
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					show_result_in_chat = true, -- Show mcp tool results in chat
					make_vars = true, -- Convert resources to #variables
					make_slash_commands = true, -- Add prompts as /slash commands
				}
			}
		}
	},
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require('nvim-treesitter.configs').setup({
					ensure_installed = { 'yaml' },
					highlight = { enable = true },
				})
			end,
		},
		{ "nvim-lua/plenary.nvim" },
		{ "hrsh7th/nvim-cmp" },
		{
			'MeanderingProgrammer/render-markdown.nvim',
			ft = { 'codecompanion' },
			opts = { file_types = { 'codecompanion' }, latex = { enabled = false } },
		},
	},
	config = function()
		vim.keymap.set('n', '<leader>aac', ':CodeCompanionActions<CR>', { desc = '[AiAC]tions pallete' })
		vim.keymap.set('n', '<leader>ai', ':CodeCompanionChat<CR>', { desc = 'Open chat wiht [AI]' })
		vim.keymap.set('n', '<leader>in', ':CodeCompanionChat<CR>', { desc = 'Open ai in [in]line mode' })

		require("codecompanion").setup({
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true, -- Show mcp tool results in chat
						make_vars = true, -- Convert resources to #variables
						make_slash_commands = true, -- Add prompts as /slash commands
					}
				}
			},
			strategies = {
				cmd = { adapter = default_adapter },
				chat = {
					adapter = default_adapter,
				},
				inline = { adapter = default_adapter },
			},
			adapters = adapters,
		})
	end
}
