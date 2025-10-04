return function(M)
  function M.parse_line(line)
    local row = vim.split(line, ",", { trimempty = true })
    for i, v in ipairs(row) do
      row[i] = vim.trim(v)
    end
    return row
  end

  function M.create_n_length_string_of(char, n)
    return string.rep(char, n)
  end

  function M.add_table(opts)
    opts = opts or {}
    local below = opts.below ~= false -- default: below
    local header_line = opts.headers or "Col1, Col2, Col3"
    local rows = opts.rows
    local width_chars = M.create_n_length_string_of("-", opts.width or 3)
    local headers = M.parse_line(header_line)
    local cols = #headers


    local tbl = {}
    -- Header
    table.insert(tbl, "| " .. table.concat(headers, " | ") .. " |")
    -- Separator
    table.insert(tbl, "|" .. string.rep(" " .. width_chars .. " |", cols))
    -- Rows
    for i = 1, #rows do
      local row = M.parse_line(rows[i])
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
    M.add_table({ below = true, rows = visual_selection, headers = first_line })
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
