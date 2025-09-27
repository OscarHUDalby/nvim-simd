local M = {}

function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  if line:find("%[ %]") then
    line = line:gsub("%[ %]", "[x]", 1)
  elseif line:find("%[x%]") then
    line = line:gsub("%[x%]", "[ ]", 1)
  else
    line = "- [ ] " .. line
  end
  vim.api.nvim_set_current_line(line)
end

function M.toggle_header(num)
  local line = vim.api.nvim_get_current_line()
  local hashes = line:match("^(#+)")
  local num_hashes = hashes and #hashes or 0
  if num_hashes == num then
    line = line:gsub("^#+%s*", "")
    vim.api.nvim_set_current_line(line)
    return
  else
    line = line:gsub("^#+%s*", "")
    if num > 0 then
      line = string.rep("#", num) .. " " .. line
    end
    vim.api.nvim_set_current_line(line)
  end
end

function M.preview_glow(split_vertical)
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then
    print("Buffer is not saved. Please save the file first.")
    return
  end
  local split_type = split_vertical and "vsplit" or "split"
  if split_vertical then
    vim.o.splitright = true
  end
  vim.cmd(split_type)
  vim.cmd("enew")
  vim.fn.termopen("glow " .. vim.fn.shellescape(filename))
  vim.cmd("startinsert")
end

function M.find_wrapper(text, wrappers)
  for _, wrapper in ipairs(wrappers) do
    local len = #wrapper
    local rev = M.reverse_wrapper(wrapper)
    if text:sub(1, len) == wrapper and text:sub(- #rev) == rev then
      return wrapper
    end
  end
  return nil
end

function M.check_if_wrapped(text, wrappers)
  return M.find_wrapper(text, wrappers) ~= nil
end

function M.wrap_text(text, wrapper)
  return wrapper .. text .. wrapper
end

function M.reverse_wrapper(wrapper)
  return wrapper:reverse()
end

function M.unwrap_text(text, wrappers)
  if type(text) ~= "string" then return text, false end
  for _, wrapper in ipairs(wrappers) do
    local len = #wrapper
    local rev = M.reverse_wrapper(wrapper)
    if text:sub(1, len) == wrapper and text:sub(- #rev) == rev then
      return text:sub(len + 1, -(#rev + 1)), true
    end
  end
  return text, false
end

function M.get_visual_selection()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
    start_pos, end_pos = end_pos, start_pos
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  return lines, start_pos, end_pos
end

function M.get_selected_text()
  local lines, start_pos, end_pos = M.get_visual_selection()
  if not lines or #lines == 0 then return "", start_pos, end_pos end
  if #lines == 1 then
    return lines[1]:sub(start_pos[3], end_pos[3]), start_pos, end_pos
  else
    local sel = {}
    sel[1] = lines[1]:sub(start_pos[3])
    for i = 2, #lines - 1 do
      table.insert(sel, lines[i])
    end
    sel[#lines] = lines[#lines]:sub(1, end_pos[3])
    return table.concat(sel, "\n"), start_pos, end_pos
  end
end

function M.replace_visual_selection(new_lines, start_pos, end_pos)
  vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, new_lines)
end

function M.toggle_wrap_text(text, wrappers, default_wrapper)
  local unwrapped, was_wrapped = M.unwrap_text(text, wrappers)
  if was_wrapped then
    return unwrapped
  else
    return M.wrap_text(text, default_wrapper)
  end
end

function M.replace_selection(new_text)
  local lines, start_pos, end_pos = M.get_visual_selection()
  if not lines or #lines == 0 then return end

  local new_lines = {}
  for line in new_text:gmatch("([^\n]*)\n?") do
    table.insert(new_lines, line)
  end

  if new_lines[#new_lines] == "" then
    table.remove(new_lines, #new_lines)
  end

  M.replace_visual_selection(new_lines, start_pos, end_pos)
end

function M.make_formatted(wrappers, default_wrapper, is_visual)
  if is_visual then
    local lines, start_pos, end_pos = M.get_visual_selection()
    if #lines == 1 then
      -- Single line selection
      local line = lines[1]
      local sel_start = start_pos[3]
      local sel_end = end_pos[3]
      if sel_start > sel_end then sel_start, sel_end = sel_end, sel_start end
      local before = line:sub(1, sel_start - 1)
      local selection = line:sub(sel_start, sel_end)
      local after = line:sub(sel_end + 1)
      local toggled = M.toggle_wrap_text(selection, wrappers, default_wrapper)
      local replaced = before .. toggled .. after
      vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, start_pos[2], false, { replaced })
    else
      -- Multi-line selection
      local text, s, e = M.get_selected_text()
      local toggled = M.toggle_wrap_text(text, wrappers, default_wrapper)
      local new_lines = {}
      for line in toggled:gmatch("([^\n]*)\n?") do
        table.insert(new_lines, line)
      end
      if new_lines[#new_lines] == "" then
        table.remove(new_lines, #new_lines)
      end
      M.replace_visual_selection(new_lines, s, e)
    end
  else
    local line = vim.api.nvim_get_current_line()
    local new_line = M.toggle_wrap_text(line, wrappers, default_wrapper)
    vim.api.nvim_set_current_line(new_line)
  end
end

-- Keybindings
vim.keymap.set('n', '<leader>np', function() M.preview_glow(true) end, { desc = "Preview markdown with glow in hsplit" })

-- Checkboxes
vim.keymap.set('n', '<leader>nc', M.toggle_checkbox, { desc = "Toggle markdown checkbox in line" })

-- Headers
vim.keymap.set('n', '<leader>n0', function() M.toggle_header(0) end, { desc = "Remove any # header in line" })
vim.keymap.set('n', '<leader>n1', function() M.toggle_header(1) end, { desc = "Toggle # header in line" })
vim.keymap.set('n', '<leader>n2', function() M.toggle_header(2) end, { desc = "Toggle ## header in line" })
vim.keymap.set('n', '<leader>n3', function() M.toggle_header(3) end, { desc = "Toggle ### header in line" })
vim.keymap.set('n', '<leader>n4', function() M.toggle_header(4) end, { desc = "Toggle #### header in line" })
vim.keymap.set('n', '<leader>n5', function() M.toggle_header(5) end, { desc = "Toggle ##### header in line" })
vim.keymap.set('n', '<leader>n6', function() M.toggle_header(6) end, { desc = "Toggle ###### header in line" })

-- Italic, Bold, Bold Italic, Strikethrough
vim.keymap.set('v', '<leader>ni', function() M.make_formatted({ "*", "_" }, "*", true) end, { desc = "Toggle italic" })
vim.keymap.set('v', '<leader>nb', function() M.make_formatted({ "**", "__" }, "**", true) end, { desc = "Toggle bold" })
vim.keymap.set('v', '<leader>no',
  function() M.make_formatted({ "***", "___", "**_" }, "***", true) end,
  { desc = "Toggle bold+italic" })
vim.keymap.set('v', '<leader>ns', function() M.make_formatted({ "~~" }, "~~", true) end,
  { desc = "Toggle strikethrough (~~)" })

vim.keymap.set('n', '<leader>ni', function() M.make_formatted({ "*", "_" }, "*", false) end, { desc = "Toggle italic" })
vim.keymap.set('n', '<leader>nb', function() M.make_formatted({ "**", "__" }, "**", false) end, { desc = "Toggle bold" })
vim.keymap.set('n', '<leader>no', function() M.make_formatted({ "***", "___", "**_" }, "***", false) end,
  { desc = "Toggle bold+italic" })
vim.keymap.set('n', '<leader>ns', function() M.make_formatted({ "~~" }, "~~", false) end,
  { desc = "Toggle strikethrough (~~)" })

return M
