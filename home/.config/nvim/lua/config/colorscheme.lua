if not vim.g.vscode then
    -- vim.cmd.colorscheme("chester")

    -- local lightline = vim.tbl_deep_extend("force", vim.api.nvim_get_var("lightline"), { colorscheme = "tokyonight" })
    -- vim.api.nvim_set_var("lightline", lightline)

    vim.cmd.colorscheme("tokyonight-storm")

    local storm = require("tokyonight.colors.storm")
    local moon = require("tokyonight.colors.moon")
    vim.api.nvim_set_hl(0, "Folded", { fg = vim.api.nvim_get_hl(0, { name = "Folded" }).fg, bg = nil })
    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = storm.green })
    vim.api.nvim_set_hl(0, "GitSignsDelte", { fg = storm.red })
    vim.api.nvim_set_hl(0, "TabLine", { fg = storm.dark3, bg = moon.bg_highlight })
    vim.api.nvim_set_hl(0, "TabLineSel", { fg = storm.blue, bg = storm.fg_gutter })
end
