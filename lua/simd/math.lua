return function(M)
  -- Keybindings
  local prefix = "<leader>" .. M.config.namespace_key .. "m"
  local mapping = "xnoremap <silent> " ..
      prefix .. " :<C-u>lua require'simd'.wrap_by_mode(vim.fn.visualmode(), '$', '$', '$$', '$$')<CR>"
  vim.cmd(mapping)
end
