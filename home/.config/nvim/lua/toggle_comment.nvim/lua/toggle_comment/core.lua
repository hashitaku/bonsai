local M = {}

---@param line string
---@param symbol string
---@return boolean
function M.is_commented(line, symbol)
    local noindent = line:gsub("^%s+", "")
    return vim.startswith(noindent, symbol)
end

---@param str string
---@return string, string
function M.split_leading_indent(str)
    local indent = str:match("^%s+") or ""
    local words = str:sub(indent:len() + 1)

    return indent, words
end

function M.get_visual_pos_range()
    local visual_start_line = vim.fn.line("v")
    local current_cursor_line = vim.fn.line(".")

    if (visual_start_line < current_cursor_line) then
        return { 0, visual_start_line, 1, 0 }, { 0, current_cursor_line, vim.v.maxcol, 0 }
    else
        return { 0, current_cursor_line, 1, 0 }, { 0, visual_start_line, vim.v.maxcol, 0 }
    end
end

function M.get_current_newline()
    if vim.bo.fileformat == "dos" then
        return "\r\n"
    elseif vim.bo.fileformat == "unix" then
        return "\n"
    else
        return "\r"
    end
end

return M
