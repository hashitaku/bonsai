local core = require("toggle_comment.core")
local config = require("toggle_comment.config").options

local M = {}

function M.setup()
    vim.api.nvim_create_user_command("ToggleComment", function(opts)
        local symbol = config.symbol[vim.bo.filetype]
        local start_pos, end_pos = core.get_visual_pos_range()
        local lines = vim.fn.getregion(start_pos, end_pos)
        local results = {}

        for idx, line in ipairs(lines) do
            if core.is_commented(line, symbol) then
                local indent, words = core.split_leading_indent(line)
                local after_symbol_char = words:sub(symbol:len() + 1, symbol:len() + 1)

                -- コメントシンボルの次の文字がスペースかタブ文字であればスキップ
                if after_symbol_char == " " or after_symbol_char == "\t" then
                    results[idx] = indent .. words:sub(symbol:len() + 2)
                else
                    results[idx] = indent .. words:sub(symbol:len() + 1)
                end
            else
                local indent, words = core.split_leading_indent(line)

                results[idx] = indent .. symbol .. " " .. words
            end
        end

        vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], true, results)
    end, { range = true })
end

return M
