local M = {}

---@class toggle_comment.Config
M.default = {
    symbol = {
        c = "//",
        cpp = "//",
        cs = "//",
        javascript = "//",
        lua = "--",
        python = "#",
        rust = "//",
        typescript = "//",
        vim = "\""
    }
}

---@param opts toggle_comment.Config
function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.default, opts or {})
end

return M
