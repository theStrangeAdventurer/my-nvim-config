local M = {}

function M.getCwdMemoryBankContent()
	local cwd = vim.fn.getcwd()
	local memory_bank_path = cwd .. "/memory-bank"
	-- Check if memory-bank directory exists
	if vim.fn.isdirectory(memory_bank_path) == 0 then
		return nil, "Memory bank directory not found"
	end

	-- Get all files in the memory-bank directory
	local files = vim.fn.glob(memory_bank_path .. "/*", false, true)

	local result = {}

	for _, filepath in ipairs(files) do
		-- Skip directories, only process files
		if vim.fn.isdirectory(filepath) == 0 then
			local filename = vim.fn.fnamemodify(filepath, ":t")
			local content = vim.fn.readfile(filepath)

			-- Add filename separator
			table.insert(result, "=== " .. filename .. " ===")

			-- Add file content
			for _, line in ipairs(content) do
				table.insert(result, line)
			end

			-- Add empty line separator
			table.insert(result, "")
		end
	end

	-- Join all lines into a single string
	return table.concat(result, "\n")
end

function M.getCwdReadme()
	local readmeVariants = {
		"README.md",
		"Readme.md",
		"README.MD",
		"readme.md",
		"README.txt",
		"README"
	}

	local cwd = vim.fn.getcwd()

	for _, variant in ipairs(readmeVariants) do
		local filepath = cwd .. "/" .. variant
		print("filePath", filepath)
		if vim.fn.filereadable(filepath) == 1 then
			return vim.fn.system({ "cat", filepath })
		end
	end

	return nil -- No README found
end

return M
