local config = require("toggle_comment.config").options

local M = {}

---@param line string
---@param symbol string
---@return boolean
local function is_commented(line, symbol)
    local noindent = line:gsub("^%s+", "")

    return vim.startswith(noindent, symbol)
end

---@param str string
---@return string, string
local function split_leading_indent(str)
    local indent = str:match("^%s+") or ""
    local words = str:sub(indent:len() + 1)

    return indent, words
end

---@return integer[], integer[]
local function get_visual_pos_range()
    local visual_start_line = vim.fn.line("v")
    local current_cursor_line = vim.fn.line(".")

    if visual_start_line < current_cursor_line then
        return { 0, visual_start_line, 1, 0 }, { 0, current_cursor_line, vim.v.maxcol, 0 }
    else
        return { 0, current_cursor_line, 1, 0 }, { 0, visual_start_line, vim.v.maxcol, 0 }
    end
end

function M.toggle_comment()
    local ft = vim.api.nvim_get_option_value("filetype", { scope = "local", buf = 0 })

    if config.symbol[ft] == nil then
        vim.api.nvim_err_writeln(string.format("[toggle_comment] filetype '%s' is not supported", ft))
        return
    end

    local symbol = config.symbol[ft]

    local start_pos, end_pos = get_visual_pos_range()
    local lines = vim.fn.getregion(start_pos, end_pos)
    local results = {}

    for idx, line in ipairs(lines) do
        if line == "" then
            results[idx] = ""
        elseif is_commented(line, symbol) then
            local indent, words = split_leading_indent(line)
            local after_symbol_char = words:sub(symbol:len() + 1, symbol:len() + 1)

            -- コメントシンボルの次の文字がスペースかタブ文字であればスキップ
            if after_symbol_char == " " or after_symbol_char == "\t" then
                results[idx] = indent .. words:sub(symbol:len() + 2)
            else
                results[idx] = indent .. words:sub(symbol:len() + 1)
            end
        else
            local indent, words = split_leading_indent(line)

            results[idx] = indent .. symbol .. " " .. words
        end
    end

    vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], true, results)
end

return M
