local M = {}

local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
local occurrence_state = {}

local function termcodes(keys)
	return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local function feed(keys, remap)
	vim.api.nvim_feedkeys(termcodes(keys), remap and "mx" or "nx", false)
end

local function current_mode()
	return vim.fn.mode(1):sub(1, 1)
end

local function is_selection_mode(mode)
	mode = mode or current_mode()
	return mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19"
end

local function to_normal()
	local mode = current_mode()
	if mode == "i" or mode == "R" then
		vim.cmd.stopinsert()
	elseif is_selection_mode(mode) then
		feed("<Esc>")
	end
end

local function line_length(row)
	return #(vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] or "")
end

local function set_cursor(row, col)
	row = math.max(1, math.min(row, vim.api.nvim_buf_line_count(0)))
	vim.api.nvim_win_set_cursor(0, { row, math.max(0, math.min(col, line_length(row))) })
end

local function start_or_extend_selection(row, col)
	local mode = current_mode()
	if mode == "i" or mode == "R" then
		vim.cmd.stopinsert()
		vim.cmd.normal({ args = { "v" }, bang = true })
	elseif not is_selection_mode(mode) then
		vim.cmd.normal({ args = { "v" }, bang = true })
	elseif mode == "s" or mode == "S" or mode == "\19" then
		feed("<C-g>")
	end
	set_cursor(row, col)
	if current_mode() == "v" or current_mode() == "V" or current_mode() == "\22" then
		feed("<C-g>")
	end
end

local function move_to(row, col, extend)
	if extend then
		start_or_extend_selection(row, col)
	else
		if is_selection_mode() then
			to_normal()
		end
		set_cursor(row, col)
	end
end

local function line_boundary(to_end, extend)
	local cursor = vim.api.nvim_win_get_cursor(0)
	move_to(cursor[1], to_end and line_length(cursor[1]) or 0, extend)
end

local function buffer_boundary(to_end, extend)
	local row = to_end and vim.api.nvim_buf_line_count(0) or 1
	move_to(row, to_end and line_length(row) or 0, extend)
end

local function normal_motion(keys, extend)
	local mode = current_mode()
	if extend then
		if mode == "i" or mode == "R" then
			vim.cmd.stopinsert()
			vim.cmd.normal({ args = { "v" }, bang = true })
		elseif not is_selection_mode(mode) then
			vim.cmd.normal({ args = { "v" }, bang = true })
		elseif mode == "s" or mode == "S" or mode == "\19" then
			feed("<C-g>")
		end
		vim.cmd.normal({ args = { keys }, bang = true })
		feed("<C-g>")
		return
	end

	if is_selection_mode(mode) then
		to_normal()
	end
	if mode == "i" or mode == "R" then
		feed("<C-o>" .. keys)
	else
		vim.cmd.normal({ args = { keys }, bang = true })
	end
end

local function char_class(char)
	if char:match("%s") then
		return "space"
	elseif char:match("%l") then
		return "lower"
	elseif char:match("%u") then
		return "upper"
	elseif char:match("%d") then
		return "digit"
	elseif char == "_" or char == "-" then
		return "separator"
	elseif char:match("%a") then
		return "letter"
	end
	return "punct"
end

local function subword_boundaries(line)
	local chars = {}
	local positions = vim.str_utf_pos(line)
	for index, byte in ipairs(positions) do
		local next_byte = positions[index + 1] or (#line + 1)
		chars[#chars + 1] = { byte = byte - 1, text = line:sub(byte, next_byte - 1) }
	end

	local boundaries = { 0 }
	for i = 2, #chars do
		local prev = char_class(chars[i - 1].text)
		local here = char_class(chars[i].text)
		local next_class = chars[i + 1] and char_class(chars[i + 1].text) or nil
		local split = prev == "separator"
			or here == "separator"
			or prev == "punct"
			or here == "punct"
			or (prev == "space" and here ~= "space")
			or (prev ~= "space" and here == "space")
			or (prev == "digit" and here ~= "digit")
			or (prev ~= "digit" and here == "digit")
			or (prev == "lower" and here == "upper")
			or (prev == "upper" and here == "upper" and next_class == "lower")
		if split then
			boundaries[#boundaries + 1] = chars[i].byte
		end
	end
	boundaries[#boundaries + 1] = #line
	return boundaries
end

local function move_subword(forward, extend)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local boundaries = subword_boundaries(line)
	local target = forward and #line or 0
	if forward then
		for _, boundary in ipairs(boundaries) do
			if boundary > cursor[2] then
				target = boundary
				break
			end
		end
	else
		for i = #boundaries, 1, -1 do
			if boundaries[i] < cursor[2] then
				target = boundaries[i]
				break
			end
		end
	end
	move_to(cursor[1], target, extend)
end

local function delete_to(target_col)
	if is_selection_mode() then
		feed('"+d')
		return
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local from, to = math.min(col, target_col), math.max(col, target_col)
	if from ~= to then
		vim.api.nvim_buf_set_text(0, row - 1, from, row - 1, to, {})
		set_cursor(row, from)
	end
end

local function delete_subword(forward)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local boundaries = subword_boundaries(line)
	local cursor_col = cursor[2]
	if current_mode() == "n" and not forward and cursor_col < #line then
		cursor_col = cursor_col + 1
	end
	local target = forward and #line or 0
	if forward then
		for _, boundary in ipairs(boundaries) do
			if boundary > cursor_col then
				target = boundary
				break
			end
		end
	else
		for i = #boundaries, 1, -1 do
			if boundaries[i] < cursor_col then
				target = boundaries[i]
				break
			end
		end
	end
	if cursor_col ~= cursor[2] then
		vim.api.nvim_buf_set_text(0, cursor[1] - 1, target, cursor[1] - 1, cursor_col, {})
		set_cursor(cursor[1], target)
	else
		delete_to(target)
	end
end

local function delete_word(forward)
	if is_selection_mode() then
		feed('"+d')
		return
	end
	if forward then
		feed(current_mode() == "i" and "<C-o>dw" or "dw")
	else
		feed(current_mode() == "i" and "<C-w>" or "db")
	end
end

local function visual_line_range()
	if not is_selection_mode() then
		local row = vim.api.nvim_win_get_cursor(0)[1]
		return row, row
	end
	local anchor = vim.fn.getpos("v")[2]
	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	return math.min(anchor, cursor), math.max(anchor, cursor)
end

local function selected_range()
	if not is_selection_mode() then
		return nil
	end
	local anchor = vim.fn.getpos("v")
	local cursor = vim.api.nvim_win_get_cursor(0)
	local a = { anchor[2] - 1, anchor[3] - 1 }
	local b = { cursor[1] - 1, cursor[2] }
	if a[1] > b[1] or (a[1] == b[1] and a[2] > b[2]) then
		a, b = b, a
	end
	local end_line = vim.api.nvim_buf_get_lines(0, b[1], b[1] + 1, true)[1] or ""
	local end_col = math.min(b[2] + 1, #end_line)
	return a[1], a[2], b[1], end_col
end

local function selected_text()
	local sr, sc, er, ec = selected_range()
	if not sr then
		return nil
	end
	return table.concat(vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {}), "\n"), sr, sc, er, ec
end

local function word_at_cursor()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local start_col = col
	while start_col > 0 and line:sub(start_col, start_col):match("[%w_]") do
		start_col = start_col - 1
	end
	local end_col = col + 1
	while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
		end_col = end_col + 1
	end
	local text = line:sub(start_col + 1, end_col - 1)
	if text == "" then
		text = line:sub(col + 1, col + 1)
		start_col, end_col = col, col + #text
	end
	return text, row - 1, start_col, row - 1, end_col
end

local function select_byte_range(sr, sc, er, ec)
	to_normal()
	set_cursor(sr + 1, sc)
	vim.cmd.normal({ args = { "v" }, bang = true })
	set_cursor(er + 1, math.max(sc, ec - 1))
	feed("<C-g>")
end

local function copy_selection()
	if is_selection_mode() then
		feed('<C-g>"+ygv<C-g>')
	end
end

local function cut_selection()
	if is_selection_mode() then
		feed('<C-g>"+d')
	else
		feed('"+dd')
	end
end

local function paste(reindent)
	local mode = current_mode()
	if mode == "i" or mode == "R" then
		feed("<C-r>+")
	elseif is_selection_mode(mode) then
		feed('<C-g>"+p')
	elseif reindent then
		feed('"+]p')
	else
		feed('"+p')
	end
	if reindent and mode == "i" then
		feed("<C-o>==")
	end
end

local function history(redo)
	local mode = current_mode()
	if is_selection_mode(mode) then
		to_normal()
		mode = "n"
	end
	feed((mode == "i" or mode == "R") and (redo and "<C-o><C-r>" or "<C-o>u") or (redo and "<C-r>" or "u"))
end

local function open_line(above)
	to_normal()
	feed(above and "O" or "o")
end

local function duplicate_lines()
	local first, last = visual_line_range()
	local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, true)
	vim.api.nvim_buf_set_lines(0, last, last, true, lines)
	set_cursor(last + 1, vim.api.nvim_win_get_cursor(0)[2])
end

local function move_lines(direction)
	local first, last = visual_line_range()
	local count = vim.api.nvim_buf_line_count(0)
	if (direction < 0 and first == 1) or (direction > 0 and last == count) then
		return
	end
	to_normal()
	if direction < 0 then
		vim.cmd(string.format("%d,%dmove %d", first, last, first - 2))
	else
		vim.cmd(string.format("%d,%dmove %d", first, last, last + 1))
	end
end

local function join_lines()
	local first, last = visual_line_range()
	to_normal()
	if first == last then
		last = math.min(last + 1, vim.api.nvim_buf_line_count(0))
	end
	vim.cmd(string.format("%d,%djoin", first, last))
end

local function indent_lines(direction)
	local first, last = visual_line_range()
	to_normal()
	vim.cmd(string.format("%d,%d%s", first, last, direction > 0 and ">" or "<"))
end

local function toggle_line_comment()
	if is_selection_mode() then
		feed("<C-g>gc", true)
	else
		to_normal()
		feed("gcc", true)
	end
end

local function block_comment_parts()
	local start_part, end_part
	for item in vim.bo.comments:gmatch("[^,]+") do
		local flag, text = item:match("^([^:]+):(.*)$")
		if flag and flag:match("^s%d*$") and not start_part then
			start_part = text:gsub("\\(.)", "%1")
		elseif start_part and flag:match("^ex%d*$") then
			end_part = text:gsub("\\(.)", "%1")
			break
		end
	end
	return start_part, end_part
end

local function toggle_block_comment()
	local text, sr, sc, er, ec = selected_text()
	if not text then
		local row = vim.api.nvim_win_get_cursor(0)[1] - 1
		text = vim.api.nvim_get_current_line()
		sr, sc, er, ec = row, 0, row, #text
	end
	local left, right = block_comment_parts()
	if not left or not right then
		toggle_line_comment()
		return
	end
	if text:sub(1, #left) == left and text:sub(-#right) == right then
		text = text:sub(#left + 1, #text - #right)
	else
		text = left .. text .. right
	end
	to_normal()
	vim.api.nvim_buf_set_text(0, sr, sc, er, ec, vim.split(text, "\n", { plain = true }))
end

local function delete_lines()
	local first, last = visual_line_range()
	to_normal()
	vim.api.nvim_buf_set_lines(0, first - 1, last, true, {})
	set_cursor(math.min(first, vim.api.nvim_buf_line_count(0)), 0)
end

local function transpose_chars()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	if #line < 2 then
		return
	end
	col = math.min(math.max(col, 1), #line - 1)
	local a, b = line:sub(col, col), line:sub(col + 1, col + 1)
	vim.api.nvim_buf_set_text(0, row - 1, col - 1, row - 1, col + 1, { b .. a })
	set_cursor(row, col + 1)
end

local function wrap_text()
	if is_selection_mode() then
		feed("<C-g>gq")
	else
		to_normal()
		feed("gqq")
	end
end

local function toggle_replace()
	if current_mode() == "R" then
		vim.cmd.stopinsert()
		vim.cmd.startinsert()
	else
		to_normal()
		vim.cmd.startreplace()
	end
end

local function syntax_select(expand)
	local mode = current_mode()
	if mode == "i" or mode == "R" then
		vim.cmd.stopinsert()
		mode = "n"
	end
	if mode == "s" or mode == "S" or mode == "\19" then
		feed("<C-g>")
		mode = "v"
	end
	if not is_selection_mode(mode) then
		local ok, node = pcall(vim.treesitter.get_node, { ignore_injections = false })
		if not ok or not node then
			return
		end
		feed("v" .. (expand and "an" or "in") .. "<C-g>", true)
	else
		feed((expand and "an" or "in") .. "<C-g>", true)
	end
end

local function cursor_exists(row, col)
	return #vim.api.nvim_buf_get_extmarks(0, mc_ns, { row, col }, { row, col }, { limit = 1 }) > 0
end

local function add_cursor(row, col)
	if not cursor_exists(row, col) then
		vim.api.nvim_buf_set_extmark(0, mc_ns, row, col, {})
	end
	vim.bo.follow = true
end

local function add_line_cursor(direction)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local target = row + direction
	if target < 1 or target > vim.api.nvim_buf_line_count(0) then
		return
	end
	add_cursor(target - 1, math.min(col, line_length(target)))
end

local function cursors_for_selected_lines()
	local first, last = visual_line_range()
	local primary_row, col = unpack(vim.api.nvim_win_get_cursor(0))
	to_normal()
	for row = first, last do
		if row ~= primary_row then
			add_cursor(row - 1, math.min(col, line_length(row)))
		end
	end
end

local function all_occurrences(text)
	local matches = {}
	if text == "" or text:find("\n", 1, true) then
		return matches
	end
	for row, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, true)) do
		local from = 1
		while true do
			local start_col = line:find(text, from, true)
			if not start_col then
				break
			end
			matches[#matches + 1] = { row - 1, start_col - 1 }
			from = start_col + math.max(#text, 1)
		end
	end
	return matches
end

local function select_occurrence_set(text, matches, primary_index)
	if #matches == 0 then
		return
	end
	vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
	for i, match in ipairs(matches) do
		if i ~= primary_index then
			add_cursor(match[1], match[2])
		end
	end
	local primary = matches[primary_index]
	select_byte_range(primary[1], primary[2], primary[1], primary[2] + #text)
end

local function occurrence_seed()
	local text, sr, sc, er, ec = selected_text()
	if text and er == sr then
		return text, sr, sc, er, ec
	end
	return word_at_cursor()
end

local function select_next_occurrence()
	local buf = vim.api.nvim_get_current_buf()
	local state = occurrence_state[buf]
	local text, sr, sc, er, ec
	if state and is_selection_mode() then
		text, sr, sc, er, ec = state.text, state.sr, state.sc, state.er, state.ec
	else
		text, sr, sc, er, ec = occurrence_seed()
		state = { text = text, sr = sr, sc = sc, er = er, ec = ec, selected = {} }
		occurrence_state[buf] = state
	end
	if not text or text == "" or er ~= sr then
		return
	end
	local matches = all_occurrences(text)
	if #matches < 2 then
		select_byte_range(sr, sc, er, ec)
		return
	end
	local current_index = 1
	for i, match in ipairs(matches) do
		if match[1] == state.sr and match[2] == state.sc then
			current_index = i
			break
		end
	end
	state.selected[current_index] = true
	local next_index = current_index % #matches + 1
	while state.selected[next_index] and next_index ~= current_index do
		next_index = next_index % #matches + 1
	end
	state.selected[next_index] = true
	state.sr, state.sc = matches[next_index][1], matches[next_index][2]
	state.er, state.ec = state.sr, state.sc + #text
	local selected = {}
	for index in pairs(state.selected) do
		selected[#selected + 1] = matches[index]
	end
	table.sort(selected, function(a, b)
		return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
	end)
	local primary_index = 1
	for i, match in ipairs(selected) do
		if match[1] == state.sr and match[2] == state.sc then
			primary_index = i
			break
		end
	end
	select_occurrence_set(text, selected, primary_index)
end

local function select_every_occurrence()
	local text, sr, sc = occurrence_seed()
	if not text or text == "" then
		return
	end
	local matches = all_occurrences(text)
	local primary = 1
	for i, match in ipairs(matches) do
		if match[1] == sr and match[2] == sc then
			primary = i
			break
		end
	end
	select_occurrence_set(text, matches, primary)
end

local function select_line()
	local first, last = visual_line_range()
	if is_selection_mode() then
		last = math.min(last + 1, vim.api.nvim_buf_line_count(0))
	end
	to_normal()
	set_cursor(first, 0)
	vim.cmd.normal({ args = { "V" }, bang = true })
	set_cursor(last, line_length(last))
	feed("<C-g>")
end

M.keys = {
	{ "<D-s>", "<cmd>w<cr>", mode = { "n", "i", "x", "s" }, desc = "write buffer" },
	{ "<D-w>", "<cmd>bdelete<cr>", mode = { "n", "i", "x", "s" }, desc = "close buffer" },
	{ "<D-a>", "<Esc>ggVG<C-g>", mode = { "n", "i", "x", "s" }, desc = "select all" },
	{ "<D-c>", copy_selection, mode = { "x", "s" }, desc = "copy selection" },
	{ "<D-x>", cut_selection, mode = { "n", "x", "s" }, desc = "cut selection or line" },
	{
		"<D-v>",
		function()
			paste(false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "paste",
	},
	{
		"<D-S-v>",
		function()
			paste(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "paste and indent",
	},
	{
		"<D-z>",
		function()
			history(false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "undo",
	},
	{
		"<D-S-z>",
		function()
			history(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "redo",
	},
	{
		"<D-y>",
		function()
			history(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "redo",
	},

	{
		"<S-Left>",
		function()
			normal_motion("h", true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select left",
	},
	{
		"<S-Right>",
		function()
			normal_motion("l", true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select right",
	},
	{
		"<S-Up>",
		function()
			normal_motion("gk", true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select up",
	},
	{
		"<S-Down>",
		function()
			normal_motion("gj", true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select down",
	},
	{
		"<A-Left>",
		function()
			normal_motion("b", false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "previous word",
	},
	{
		"<A-Right>",
		function()
			normal_motion("w", false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "next word",
	},
	{
		"<A-S-Left>",
		function()
			normal_motion("b", true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select previous word",
	},
	{
		"<A-S-Right>",
		function()
			normal_motion("w", true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select next word",
	},
	{
		"<C-Left>",
		function()
			move_subword(false, false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "previous subword",
	},
	{
		"<C-Right>",
		function()
			move_subword(true, false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "next subword",
	},
	{
		"<C-S-Left>",
		function()
			move_subword(false, true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select previous subword",
	},
	{
		"<C-S-Right>",
		function()
			move_subword(true, true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select next subword",
	},
	{
		"<D-Left>",
		function()
			line_boundary(false, false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "line start",
	},
	{
		"<D-Right>",
		function()
			line_boundary(true, false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "line end",
	},
	{
		"<D-S-Left>",
		function()
			line_boundary(false, true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select to line start",
	},
	{
		"<D-S-Right>",
		function()
			line_boundary(true, true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select to line end",
	},
	{
		"<D-Up>",
		function()
			buffer_boundary(false, false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "buffer start",
	},
	{
		"<D-Down>",
		function()
			buffer_boundary(true, false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "buffer end",
	},
	{
		"<D-S-Up>",
		function()
			buffer_boundary(false, true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select to buffer start",
	},
	{
		"<D-S-Down>",
		function()
			buffer_boundary(true, true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "select to buffer end",
	},
	{
		"<A-BS>",
		function()
			delete_word(false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "delete previous word",
	},
	{
		"<A-Del>",
		function()
			delete_word(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "delete next word",
	},
	{
		"<C-BS>",
		function()
			delete_subword(false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "delete previous subword",
	},
	{
		"<C-Del>",
		function()
			delete_subword(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "delete next subword",
	},
	{
		"<D-BS>",
		function()
			delete_to(0)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "delete to line start",
	},
	{
		"<D-Del>",
		function()
			delete_to(line_length(vim.api.nvim_win_get_cursor(0)[1]))
		end,
		mode = { "n", "i", "x", "s" },
		desc = "delete to line end",
	},

	{
		"<D-CR>",
		function()
			open_line(false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "new line below",
	},
	{
		"<D-S-CR>",
		function()
			open_line(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "new line above",
	},
	{ "<D-S-d>", duplicate_lines, mode = { "n", "i", "x", "s" }, desc = "duplicate selection or line" },
	{
		"<C-D-Up>",
		function()
			move_lines(-1)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "move lines up",
	},
	{
		"<C-D-Down>",
		function()
			move_lines(1)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "move lines down",
	},
	{ "<D-S-j>", join_lines, mode = { "n", "i", "x", "s" }, desc = "join lines" },
	{
		"<D-[>",
		function()
			indent_lines(-1)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "unindent lines",
	},
	{
		"<D-]>",
		function()
			indent_lines(1)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "indent lines",
	},
	{ "<D-/>", toggle_line_comment, mode = { "n", "i", "x", "s" }, desc = "toggle line comment" },
	{ "<D-A-/>", toggle_block_comment, mode = { "n", "i", "x", "s" }, desc = "toggle block comment" },
	{ "<C-S-k>", delete_lines, mode = { "n", "i", "x", "s" }, desc = "delete lines" },
	{ "<C-t>", transpose_chars, mode = { "n", "i" }, desc = "transpose characters" },
	{ "<D-A-q>", wrap_text, mode = { "n", "i", "x", "s" }, desc = "wrap text" },
	{ "<D-A-o>", toggle_replace, mode = { "n", "i" }, desc = "toggle replace mode" },

	{
		"<C-D-Right>",
		function()
			syntax_select(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "expand syntax selection",
	},
	{
		"<C-D-Left>",
		function()
			syntax_select(false)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "shrink syntax selection",
	},
	{
		"<D-S-Space>",
		function()
			syntax_select(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "expand syntax selection",
	},
	{
		"<D-S-a>",
		function()
			syntax_select(true)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "expand syntax selection",
	},

	{ "<D-l>", select_line, mode = { "n", "i", "x", "s" }, desc = "select line" },
	{ "<D-d>", select_next_occurrence, mode = { "n", "i", "x", "s" }, desc = "select next occurrence" },
	{ "<C-D-g>", select_every_occurrence, mode = { "n", "i", "x", "s" }, desc = "select all occurrences" },
	{
		"<C-S-Up>",
		function()
			add_line_cursor(-1)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "add cursor above",
	},
	{
		"<C-S-Down>",
		function()
			add_line_cursor(1)
		end,
		mode = { "n", "i", "x", "s" },
		desc = "add cursor below",
	},
	{ "<D-S-l>", cursors_for_selected_lines, mode = { "x", "s" }, desc = "split selection into lines" },
}

return M.keys
