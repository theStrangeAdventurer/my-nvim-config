if (vim.env._LLM_DEFAULT_PLUGIN and vim.env._LLM_DEFAULT_PLUGIN ~= 'codecompanion') then
	return {}
end
print "codecompanion was loaded..."

local _default_adapter = 'ollama'
local adapters = {
	ollama = function()
		local openai = require("codecompanion.adapters.openai")
		return require("codecompanion.adapters").extend("openai_compatible", {
			schema = {
				model = {
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
				temperature = {
					default = 0.2
				}
			},
		})
	end,
	anthropic = function()
		return require("codecompanion.adapters").extend("anthropic", {
			env = {
				api_key = vim.env.ANTHROPIC_API_KEY,
			},
			schema = {
				model = {
					default = "claude-3-7-sonnet-20250219",
					-- default = "claude-3-7-sonnet-latest"
				},
				temperature = {
					default = 0.2
				}
			}
		})
	end,
	custom_deepseek = vim.env.CUSTOM_DEEPSEEK_URL and function()
		return require("codecompanion.adapters").extend("openai_compatible", {
			formatted_name = "Custom Deepseek",
			env = {
				url = vim.env.CUSTOM_DEEPSEEK_URL,
				api_key = vim.env.CUSTOM_DEEPSEEK_TOKEN,
				chat_url = "/v1/chat/completions",
			},
			schema = {
				model = {
					-- default = "communal-deepseek-v3-0324-in-yt",
				},
				temperature = {
					default = 0.0
				}
			},
		})
	end or nil,
	custom_anthropic = vim.env.CUSTOM_ANTHROPIC_URL and function()
		return require("codecompanion.adapters").extend("anthropic", {
			formatted_name = "Custom Anthropic",
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

		local config = require("codecompanion.config")
		require("codecompanion").setup({
			--- @class PromptContext
			--- @field bufnr number
			--- @field buftype string
			--- @field cursor_pos number[]
			--- @field end_col number
			--- @field end_line number
			--- @field filetype string
			--- @field is_normal boolean
			--- @field is_visual boolean
			--- @field lines string[]
			--- @field mode string
			--- @field start_col number
			--- @field start_line number
			--- @field winnr number
			--- @example "https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua"
			prompt_library = {
				["Project Expert"] = {
					strategy = "chat",
					description = "Expert experienced at your project",
					opts = {
						-- modes = { "v", "i" },
						short_name = "pe",
						-- auto_submit =  true,
						-- stop_context_insertion = true,
						-- user_prompt = true,
					},
					prompts = {
						{
							role = config.constants.SYSTEM_ROLE,
							--- @param context PromptContext
							content = function(context)
								local content =
								"You are a code expert and you can resolve any complex task in any programming language. You should always respond in the user's question language"
								local readme = require("utils.project").getCwdReadme()

								if readme then
									content = content .. "\n\n Project README file content: \n" .. readme
								end

								local memoryBankContent = require("utils.project").getCwdMemoryBankContent()
								if memoryBankContent then
									content = content .. "\n\n Project context: \n" .. memoryBankContent
								end

								return content
							end
						},

						{
							role = config.constants.USER_ROLE,
							content = [[#{buffer} #{lsp}
Could you please ...]]
						},
					},
				}
			},
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
