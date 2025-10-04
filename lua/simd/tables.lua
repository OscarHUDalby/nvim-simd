return function(M)
  function M.parse_headers(header_line)
    local headers = vim.split(header_line, ",", { trimempty = true })
    for i, v in ipairs(headers) do
      headers[i] = vim.trim(v)
    end
    return headers
  end

  function M.create_n_length_string_of(char, n)
    return string.rep(char, n)
  end

  function M.add_table(opts)
    opts = opts or {}
    local below = opts.below ~= false -- default: below
    local header_line = opts.headers or "Col1, Col2, Col3"
    local rows = opts.rows            -- should be based on header_line
    local width = opts.width or 4
    local width_chars = M.create_n_length_string_of("-", width)
    local headers = M.parse_headers(header_line)
    local cols = #headers

    local tbl = {}
    -- Header
    table.insert(tbl, "| " .. table.concat(headers, " | ") .. " |")
    -- Separator
    table.insert(tbl, "|" .. string.rep(" " .. width_chars .. " |", cols))
    -- Rows
    for i = 1, #rows do
      local row = rows[i]
      -- Now you can use the contents of `row`
      -- For example, print each cell if row is a table:
      local line = "|"
      for j = 1, cols do
        local cell = row[j] or ""
        line = line .. " " .. tostring(cell) .. " |"
      end
      table.insert(tbl, line)
    end

    local cur = vim.api.nvim_win_get_cursor(0)
    local line = cur[1]
    local insert_at = below and line or (line - 1)
    vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, tbl)
  end

  function M.auto_add_table()
    local visual_selection = M.get_visual_selection()
    if not visual_selection or #visual_selection == 0 then return end
    local first_line = table.remove(visual_selection, 1)
    M.logger.window(first_line, { x_offset = 100 })
    M.logger.window(rows)
    -- M.add_table({ below = true, rows = rows, headers = first_line })
  end

  local prefix = "<leader>" .. M.config.namespace_key
  vim.keymap.set('n', prefix .. 't', function()
    M.add_table({ below = true, rows = 3, headers = "Name,Email,Role" })
  end, { desc = "Insert markdown table" })

  vim.keymap.set('n', prefix .. 'y', function()
    M.auto_add_table()
  end, { desc = "Automatically parse headers into markdown table" })

  vim.keymap.set({ 'v', 'x' }, prefix .. 'y', function()
    M.auto_add_table()
  end, { desc = "Automatically parse headers into markdown table" })
end
