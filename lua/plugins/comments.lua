-- https://github.com/numToStr/Comment.nvim

return {
    'numToStr/Comment.nvim',
    keys = {
	{
		"<leader>]",
		function()
			    local api = require('Comment.api');
			    
			    print("current mode => " .. api)
		end,
		desc = "Comment current line"
	},
	{
		    "<leader>/",
		    function()
			    local api = require('Comment.api')
			    api.toggle.linewise.current();
		end,
		desc = "Comment current line"
	},
    }
}
