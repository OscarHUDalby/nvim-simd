return function(M)
  local function get_visual_range()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    return start_line, end_line
  end

  function M.increment_blockquote()
    if vim.fn.mode() == 'V' then
      local start_line, end_line = get_visual_range()
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      for i, line in ipairs(lines) do
        lines[i] = "> " .. line
      end
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    else
      local line = vim.api.nvim_get_current_line()
      vim.api.nvim_set_current_line("> " .. line)
    end
  end

  function M.decrement_blockquote()
    if vim.fn.mode() == 'V' then
      local start_line, end_line = get_visual_range()
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("^%s*>%s*", "", 1)
      end
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    else
      local line = vim.api.nvim_get_current_line()
      vim.api.nvim_set_current_line(line:gsub("^%s*>%s*", "", 1))
    end
  end

  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key
  vim.keymap.set('n', prefix .. ">", M.increment_blockquote, { desc = "Increment blockquote" })
  vim.keymap.set('x', prefix .. ">", M.increment_blockquote, { desc = "Increment blockquote (visual)" })
  vim.keymap.set('n', prefix .. "<", M.decrement_blockquote, { desc = "Decrement blockquote" })
  vim.keymap.set('x', prefix .. "<", M.decrement_blockquote, { desc = "Decrement blockquote (visual)" })
end
