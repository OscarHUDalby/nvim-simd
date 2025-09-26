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

function M.make_italic()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local before = line:sub(1, col - 1)
  local after = line:sub(col)
  if before:sub(-1) == "*" and after:sub(1, 1) == "*" then
    before = before:sub(1, -2)
    after = after:sub(2)
  else
    before = before .. "*"
    after = "*" .. after
  end
  vim.api.nvim_set_current_line(before .. after)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
end

function M.make_bold()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local before = line:sub(1, col - 1)
  local after = line:sub(col)
  if before:sub(-2) == "**" and after:sub(1, 2) == "**" then
    before = before:sub(1, -3)
    after = after:sub(3)
  else
    before = before .. "**"
    after = "**" .. after
  end
  vim.api.nvim_set_current_line(before .. after)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
end

function M.make_bold_italic()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local before = line:sub(1, col - 1)
  local after = line:sub(col)
  if before:sub(-3) == "***" and after:sub(1, 3) == "***" then
    before = before:sub(1, -4)
    after = after:sub(4)
  else
    before = before .. "***"
    after = "***" .. after
  end
  vim.api.nvim_set_current_line(before .. after)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
end

function M.make_strikethrough()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local before = line:sub(1, col - 1)
  local after = line:sub(col)
  if before:sub(-2) == "~~" and after:sub(1, 2) == "~~" then
    before = before:sub(1, -3)
    after = after:sub(3)
  else
    before = before .. "~~"
    after = "~~" .. after
  end
  vim.api.nvim_set_current_line(before .. after)
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col })
end

-- Keybindings
vim.keymap.set('n', '<leader>np', function() M.preview_glow(true) end,
  { desc = "Preview markdown with glow in hsplit" })
vim.keymap.set('n', '<leader>nl', function() M.preview_glow(false) end,
  { desc = "Preview markdown with glow in vsplit" })

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
vim.keymap.set('n', '<leader>ni', function() M.make_italic() end, { desc = "Make line italic" })
vim.keymap.set('n', '<leader>nb', function() M.make_bold() end, { desc = "Make line bold" })
vim.keymap.set('n', '<leader>no', function() M.make_bold_italic() end, { desc = "Make line bold & italic" })
vim.keymap.set('n', '<leader>ns', function() M.make_strikethrough() end, { desc = "Make line strikethrough" })

return M
