vim.api.nvim_create_user_command("ToSnakeFromCamel", function(_)
    local cword = vim.fn.expand("<cword>")

    local snake = cword:gsub("(%u)", "_%1"):gsub("^_", ""):lower()

    vim.cmd.normal({ args = { "ciw" .. snake }, bang = true })
    vim.cmd.normal("b")
end, {})

vim.api.nvim_create_user_command("ToCamelFromSnake", function(_)
    local cword = vim.fn.expand("<cword>")

    local camel = cword
        :gsub("_(%l)", function(c)
            return c:upper()
        end)
        :gsub("^_", "")

    vim.cmd.normal({ args = { "ciw" .. camel }, bang = true })
    vim.cmd.normal("b")
end, {})

vim.api.nvim_create_user_command("Grep", function(tbl)
    vim.cmd.grep({ args = { tbl.args }, bang = true, mods = { silent = true } })
end, {
    nargs = 1,
})

vim.api.nvim_create_user_command("DiffOrig", function()
    local current_winnr = vim.api.nvim_get_current_win()
    local new_bufnr = vim.api.nvim_create_buf(false, true)

    local new_winnr = vim.api.nvim_open_win(new_bufnr, true, {
        split = "right",
        win = 0,
    })

    local alt_file_path = vim.fn.expand("#")

    if alt_file_path == "" then
        vim.notify("DiffOrig: not exists alternate file", vim.log.levels.ERROR)
        vim.api.nvim_win_close(new_winnr, true)
        return
    end

    local file = io.open(alt_file_path, "r")

    if not file then
        vim.notify("DiffOrig: alternate file open error", vim.log.levels.ERROR)
        vim.api.nvim_win_close(new_winnr, true)
        return
    end

    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end

    file:close()

    vim.api.nvim_buf_set_lines(new_bufnr, 0, 1, true, lines)

    vim.api.nvim_set_current_win(new_winnr)
    vim.cmd.diffthis()
    vim.api.nvim_set_current_win(current_winnr)
    vim.cmd.diffthis()
end, {})
