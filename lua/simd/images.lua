return function(M)
  function M.wrap_image(mode, end_mode)
    M.wrap_by_mode(mode,
      { inline_opening = "![", inline_closing = "]()", block_opening = "[", block_closing = "](url)" })

    if end_mode == "insert" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>f(a', true, false, true), 'n', false)
    elseif end_mode == "normal" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>f(', true, false, true), 'n', false)
    end
  end

  -- Keybindings
  local image_mode = M.config.images and M.config.images.image_mode or "normal"
  local prefix = "<leader>" .. M.config.namespace_key .. "i"
  local mapping = "xnoremap <silent> " ..
      prefix ..
      " :<C-u>lua require'simd'.wrap_image(vim.fn.visualmode(), '" .. image_mode .. "')<CR>"
  vim.cmd(mapping)
end
