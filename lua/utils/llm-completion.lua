local M = {}

function M.completefunc(findstart, base)
	-- The first condition `if findstart == 1` is part of Vim's completion function protocol. Here's why it's needed:
	--
	-- 1. Vim calls completion functions twice:
	--    - First time with `findstart=1` to determine the start position of the text to complete
	--    - Second time with `findstart=0` to get the actual completion items
	--
	-- 2. In this case:
	--    - When `findstart=1`, it calculates where the completion should start by finding the last dot before cursor
	--    - When `findstart=0`, it returns filtered completion items based on the `base` (text to complete)
	if findstart == 1 then
		-- Return start position
		return vim.fn.match(vim.fn.getline('.'), '\\.\\%' .. vim.fn.col('.') .. 'c')
	else
		-- Return completion items
		local items = {}
		if vim.bo.filetype == 'codecompanion' then
			items = {
				{ word = '#buffer', info = 'add current buffer to the context' },
				{ word = '@editor', info = 'assistant can use filesystem' },
			}
		end
		-- Filter based on input
		return vim.tbl_filter(function(item)
			return vim.startswith(item.word, base)
		end, items)
	end
end

return M
