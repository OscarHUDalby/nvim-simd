return function(M)
  function M.get_visual_selection_math()
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

  function M.wrap_block(opening, closing)
    local lines, start_pos, end_pos = M.get_visual_selection_math()
    if not lines or #lines == 0 then return end
    -- local opening = "$$"
    -- local closing = "$$"
    local new_lines = {}
    table.insert(new_lines, opening)
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, closing)
    M.replace_visual_selection(new_lines, start_pos, end_pos)
  end

  function M.wrap_math(mode, inline_opening, inline_closing, block_opening, block_closing)
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
        local replaced = before .. inline_opening .. selection .. inline_closing .. after
        vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, start_pos[2], false, { replaced })
      else
        M.wrap_block(block_opening, block_closing)
      end
    elseif mode == "V" then
      M.wrap_block(block_opening, block_closing)
    end
  end

  function M.wrap_by_mode(mode, opts)
    opts                 = opts or {}
    local allow_inline   = opts.allow_inline == nil and true or opts.allow_inline
    local inline_opening = opts.inline_opening or ""
    local inline_closing = opts.inline_closing or ""
    local allow_block    = opts.allow_block == nil and true or opts.allow_block
    local block_opening  = opts.block_opening or ""
    local block_closing  = opts.block_closing or ""
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
      if allow_inline == false then return end
      if #lines == 1 then
        local line = lines[1]
        local sel_start = start_pos[3]
        local sel_end = end_pos[3]
        if sel_start > sel_end then sel_start, sel_end = sel_end, sel_start end
        local before = line:sub(1, sel_start - 1)
        local selection = line:sub(sel_start, sel_end)
        local after = line:sub(sel_end + 1)
        local replaced = before .. inline_opening .. selection .. inline_closing .. after
        vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, start_pos[2], false, { replaced })
      else
        M.wrap_block(block_opening, block_closing)
      end
    elseif mode == "V" then
      if allow_block == false then return end
      M.wrap_block(block_opening, block_closing)
    end
  end
end
