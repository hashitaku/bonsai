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
