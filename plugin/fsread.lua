local M = { on = false }
local ns_id = vim.api.nvim_create_namespace("fsread")

vim.g.flow_strength = vim.g.flow_strength or 0.7

function M.create(opts)
	M.on = true

	local line_start = 0
	local line_end = vim.api.nvim_buf_line_count(0)
	if opts and opts.range == 2 then -- Use visual range
		line_start = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
		line_end = vim.api.nvim_buf_get_mark(0, ">")[1]
	end

	local lines = vim.api.nvim_buf_get_lines(0, line_start, line_end, true)
	local i = line_start - 1
	for _, line in pairs(lines) do
		i = i + 1
		vim.api.nvim_buf_set_extmark(0, ns_id, i, 0, {
			hl_group = "FSSuffix",
			end_col = #line,
		})
		local st = nil
		local len = #line
		for j = 1, len do
			local cur = string.sub(line, j, j)
			local re = cur:match("[%w']+")
			if st then
				if j == len then
					if re then
						j = j + 1
						re = nil
					end
				end
				if not re then
					local en = j - 1
					vim.api.nvim_buf_set_extmark(0, ns_id, i, st - 1, {
						hl_group = "FSPrefix",
						end_col = math.floor(st + math.min((en - st) / 2, (en - st) * vim.g.flow_strength)),
					})
					st = nil
				end
			elseif re then
				st = j
			end
		end
	end
end

function M.clear()
	M.on = false
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
	ns_id = vim.api.nvim_create_namespace("fsread")
end

function M.toggle(opts)
	M.on = not M.on
	if M.on then
		M.create(opts)
	else
		M.clear()
	end
end

vim.api.nvim_create_user_command("FSRead", function(opts)
	M.create(opts)
end, {
	range = 2,
})

vim.api.nvim_create_user_command("FSClear", function()
	M.clear()
end, {
	range = 2,
})

vim.api.nvim_create_user_command("FSToggle", function(opts)
	M.toggle(opts)
end, {
	range = 2,
})

function M.highlight()
	if vim.g.skip_flow_default_hl then
		return
	end
	if vim.o.background == "dark" then
		vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
		vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
	else
		vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#000000", bold = true })
		vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#4C4F69" })
	end
end

M.highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		if M.on then
			M.clear()
			M.create()
			M.highlight()
		end
	end,
})
