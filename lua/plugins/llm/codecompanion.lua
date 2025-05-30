local _default_adapter = 'gemma'

local adapters = {
	-- Посмотреть реализацию для ollama
	-- https://github.com/nhac43/dotfiles/blob/b3cce533551ea63d2d732ec38412dbee38d615ac/nvim/lua/codecompanion_config.lua#L4
	gemma = function()
		return require("codecompanion.adapters").extend("openai_compatible", {
			name = "gemma",
			formatted_name = "Ollama",
			roles = {
				llm = "assistant",
				user = "user",
				tool = "tool",
			},
			opts = {
				stream = false,
				tools = true,
				vision = false,
			},
			schema = {
				model = {
					-- WIP
					default = "qwen2.5:14b",
					-- default = "llama3.1:8b",
					-- default = "gemma3:12b",
				},
			},
		})
	end,
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
else
	default_adapter = _default_adapter
end


return {
	'olimorris/codecompanion.nvim',
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{ "nvim-lua/plenary.nvim" },
		{ "hrsh7th/nvim-cmp" },
		{
			'MeanderingProgrammer/render-markdown.nvim',
			ft = { 'codecompanion' },
			opts = { file_types = { 'codecompanion' } },
		},
	},
	config = function()
		vim.keymap.set('n', '<leader>ai', ':CodeCompanionChat<CR>', { desc = 'Open chat wiht [AI]' })
		vim.keymap.set('n', '<leader>in', ':CodeCompanionChat<CR>', { desc = 'Open ai in [in]line mode' })

		require("codecompanion").setup({
			strategies = {
				cmd = { adapter = default_adapter },
				chat = { adapter = default_adapter },
				inline = { adapter = default_adapter },
			},
			adapters = adapters,
		})
	end
}
