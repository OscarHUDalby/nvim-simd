local M = {}

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
