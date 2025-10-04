return function(M)
  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key .. "m"
  local mapping = "xnoremap <silent> " ..
      prefix ..
      " :<C-u>lua require'simd'.wrap_by_mode(vim.fn.visualmode(), { inline_opening = '$', inline_closing = '$', block_opening = '$$', block_closing = '$$' })<CR>"
  vim.cmd(mapping)
end
