local function add_emoji(emoji)
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_set_current_line(line .. " " .. emoji)
end

vim.keymap.set('n', '<leader>nt', function() add_emoji("✅") end, { desc = "Add tick emoji" })
vim.keymap.set('n', '<leader>nx', function() add_emoji("❌") end, { desc = "Add cross emoji" })
