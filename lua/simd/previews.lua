return function(M)
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

  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key
  vim.keymap.set('n', prefix .. 'p', function() M.preview_glow(true) end,
    { desc = "Preview markdown with glow in hsplit" })
end
