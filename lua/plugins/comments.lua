-- https://github.com/numToStr/Comment.nvim

return {
    'numToStr/Comment.nvim',
    config = function()
	local api = require('Comment.api')
	vim.keymap.set('v', '<leader>]', api.toggle.blockwise.current)
	vim.keymap.set('n', '<leader>]', api.toggle.blockwise.current)
    end,
    keys = {
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

