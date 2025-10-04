return function(M)
  function M.wrap_link(mode, end_mode)
    M.wrap_by_mode(mode,
      { inline_opening = "[", inline_closing = "]()", block_opening = "[", block_closing = "](url)" })

    if end_mode == "insert" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>f(a', true, false, true), 'n', false)
    elseif end_mode == "normal" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>f(', true, false, true), 'n', false)
    end
  end

  -- Keybindings
  local link_mode = M.config.links and M.config.links.link_mode or "normal"
  local prefix = "<leader>" .. M.config.namespace_key .. "l"
  local mapping = "xnoremap <silent> " ..
      prefix ..
      " :<C-u>lua require'simd'.wrap_link(vim.fn.visualmode(), '" .. link_mode .. "')<CR>"
  vim.cmd(mapping)
end
