local M = {}


M.logger = {
  window = function(msg, opts)
    opts = opts or {}
    local x_offset = opts.x_offset or 10
    local y_offset = opts.y_offset or 10
    local width = opts.width or 50
    local height = opts.height or 10
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(vim.inspect(msg), "\n"))
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = y_offset,
      col = x_offset,
      style = 'minimal'
    })
  end,
  info = function(msg)
    vim.api.nvim_echo({ { "[INFO] " .. vim.inspect(msg), "Normal" } }, true, {})
  end,
  warn = function(msg)
    vim.api.nvim_echo({ { "[WARN] " .. vim.inspect(msg), "WarningMsg" } }, true, {})
  end,
  error = function(msg)
    vim.api.nvim_echo({ { "[ERROR] " .. vim.inspect(msg), "ErrorMsg" } }, true, {})
  end,
}

M.config = {
  namespace_key = "n",
  links = {
    link_mode = "normal" -- or "insert"
  },
  images = {
    image_mode = "normal" -- or "insert"
  }
}

function M.setup(opts)
  opts = opts or {}
  M.config.namespace_key = opts.namespace_key or M.config.namespace_key

  if opts.links and opts.links.link_mode then
    M.config.links.link_mode = opts.links.link_mode
  end

  if opts.images and opts.images.image_mode then
    M.config.images.image_mode = opts.images.image_mode
  end
end

require("simd.utils_wrapping")(M)
require("simd.utils_folding")(M)
require("simd.text_formatting")(M)
require("simd.code")(M)
require("simd.links")(M)
require("simd.images")(M)
require("simd.math")(M)
require("simd.headers")(M)
require("simd.checkboxes")(M)
require("simd.blockquotes")(M)
require("simd.rules")(M)
require("simd.tables")(M)
require("simd.previews")(M)


return M
