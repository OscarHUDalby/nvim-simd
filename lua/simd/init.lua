local M = {}

M.config = {
  namespace_key = "n"
}

function M.setup(opts)
  M.config.namespace_key = opts and opts.namespace_key or "n"
end

require("simd.wrapping")(M)
require("simd.code")(M)
require("simd.previews")(M)
require("simd.headers")(M)
require("simd.checkboxes")(M)
require("simd.blockquotes")(M)


return M
