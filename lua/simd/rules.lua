-- rules
return function(M)
  function M.add_rule(dir)
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1]
    local lines_up = { "", "---", "" }
    local lines_down = { "", "---", "", "" }
    dir = dir or "down"

    if dir == "up" then
      vim.api.nvim_buf_set_lines(0, row - 1, row - 1, true, lines_up)
      -- vim.api.nvim_win_set_cursor(0, { row - 1 + #lines, 0 })
    else -- "below"
      vim.api.nvim_buf_set_lines(0, row, row, true, lines_down)
      vim.api.nvim_win_set_cursor(0, { row + #lines_down, 0 })
      vim.cmd('startinsert')
    end
  end

  local prefix = "<leader>" .. M.config.namespace_key
  vim.keymap.set('n', prefix .. 'r', function() M.add_rule("down") end, { desc = "Toggle italic" })
  vim.keymap.set('n', prefix .. 'R', function() M.add_rule("up") end, { desc = "Toggle italic" })
end
