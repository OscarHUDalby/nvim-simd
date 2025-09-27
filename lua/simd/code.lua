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

  function M.wrap_code_block()
    local lines, start_pos, end_pos = M.get_visual_selection_code()
    if not lines or #lines == 0 then return end
    local opening = "```lang"
    local closing = "```"
    local new_lines = {}
    table.insert(new_lines, opening)
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, closing)
    M.replace_visual_selection(new_lines, start_pos, end_pos)
  end

  function M.get_visual_mode()
    local visual_mode = vim.fn.visualmode()
    if visual_mode == "v" then
      return "v"
    elseif visual_mode == "V" then
      return "V"
    elseif visual_mode == "\22" then
      return "CTRL-V"
    end
  end

  function M.wrap_code(mode)
    if mode == "v" then
      vim.notify("Wrapping in inline code")
      function M.replace_visual_selection(new_lines, start_pos, end_pos)
        vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, new_lines)
      end
    elseif mode == "V" then
      vim.notify("Wrapping in code block")
      M.wrap_code_block()
    end
  end

  vim.cmd [[
  xnoremap <silent> <leader>nc :<C-u>lua require'simd'.wrap_code(vim.fn.visualmode())<CR>
]]
end
