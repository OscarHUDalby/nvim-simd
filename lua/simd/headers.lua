return function(M)
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

  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key

  vim.keymap.set('n', prefix .. '0', function() M.toggle_header(0) end, { desc = "Remove any # header in line" })
  vim.keymap.set('n', prefix .. '1', function() M.toggle_header(1) end, { desc = "Toggle # header in line" })
  vim.keymap.set('n', prefix .. '2', function() M.toggle_header(2) end, { desc = "Toggle ## header in line" })
  vim.keymap.set('n', prefix .. '3', function() M.toggle_header(3) end, { desc = "Toggle ### header in line" })
  vim.keymap.set('n', prefix .. '4', function() M.toggle_header(4) end, { desc = "Toggle #### header in line" })
  vim.keymap.set('n', prefix .. '5', function() M.toggle_header(5) end, { desc = "Toggle ##### header in line" })
  vim.keymap.set('n', prefix .. '6', function() M.toggle_header(6) end, { desc = "Toggle ###### header in line" })
end
