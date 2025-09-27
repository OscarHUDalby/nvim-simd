return function(M)
  function M.get_visual_selection_code()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
      start_pos, end_pos = end_pos, start_pos
    end
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
    if #lines == 1 then
      lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
      lines[1] = string.sub(lines[1], start_pos[3])
      lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end
    return lines, start_pos, end_pos
  end

  function M.replace_visual_selection(new_lines, start_pos, end_pos)
    vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, new_lines)
  end

  function M.wrap_code_block()
    local lines, start_pos, end_pos = M.get_visual_selection_code()
    if not lines or #lines == 0 then return end
    local opening = "```"
    local closing = "```"
    local new_lines = {}
    table.insert(new_lines, opening)
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, closing)
    M.replace_visual_selection(new_lines, start_pos, end_pos)
  end

  function M.wrap_code(mode)
    if mode ~= "v" and mode ~= "V" then
      return
    end

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
      start_pos, end_pos = end_pos, start_pos
    end
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

    if mode == "v" then
      if #lines == 1 then
        local line = lines[1]
        local sel_start = start_pos[3]
        local sel_end = end_pos[3]
        if sel_start > sel_end then sel_start, sel_end = sel_end, sel_start end
        local before = line:sub(1, sel_start - 1)
        local selection = line:sub(sel_start, sel_end)
        local after = line:sub(sel_end + 1)
        local replaced = before .. "`" .. selection .. "`" .. after
        vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, start_pos[2], false, { replaced })
      else
        M.wrap_code_block()
      end
    elseif mode == "V" then
      M.wrap_code_block()
    end
  end

  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key .. "c"
  local mapping = "xnoremap <silent> " .. prefix .. " :<C-u>lua require'simd'.wrap_code(vim.fn.visualmode())<CR>"
  vim.cmd(mapping)
end
