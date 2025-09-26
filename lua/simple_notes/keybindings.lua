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

-- Keybindings
vim.keymap.set('n', '<leader>nt', M.toggle_checkbox, { desc = "Toggle markdown checkbox" })

return M
