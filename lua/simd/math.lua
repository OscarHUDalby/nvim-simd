return function(M)
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

  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key .. "m"
  local mapping = "xnoremap <silent> " ..
      prefix .. " :<C-u>lua require'simd'.wrap_math(vim.fn.visualmode(), '$', '$', '$$', '$$')<CR>"
  vim.cmd(mapping)
end
