return function(M)
  function M.fold_lines(start_line, end_line)
    vim.api.nvim_command(string.format('%d,%dfold', start_line, end_line))
  end
end
