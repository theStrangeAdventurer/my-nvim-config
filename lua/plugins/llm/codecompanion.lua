local adapters = {
	qwen3 = function()
		return require("codecompanion.adapters").extend("ollama", {
			name = "qwen3",
			schema = {
				model = {
					default = "qwen3:14b",
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

local default_strategy
if vim.env._LLM_DEFAULT_STRATEGY then
	default_strategy = vim.env._LLM_DEFAULT_STRATEGY
elseif adapters and adapters.custom_anthropic then
	default_strategy = 'custom_anthropic'
else
	default_strategy = 'qwen3'
end


return {
	'olimorris/codecompanion.nvim',
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{ "cuducos/yaml.nvim" },
		{ "nvim-lua/plenary.nvim" },
		{ "hrsh7th/nvim-cmp" },
		{
			'MeanderingProgrammer/render-markdown.nvim',
			ft = { 'codecompanion' },
			opts = { file_types = { 'codecompanion' } },
		},
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				cmd = { adapter = default_strategy },
				chat = { adapter = default_strategy },
				inline = { adapter = default_strategy },
			},
			adapters = adapters,
		})
	end
}
