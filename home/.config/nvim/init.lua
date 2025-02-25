-- options
vim.g.mapleader = " "
vim.api.nvim_set_option_value("clipboard", "unnamed,unnamedplus", {})
vim.api.nvim_set_option_value("cmdheight", vim.g.vscode and 1 or 0, {})
vim.api.nvim_set_option_value("cursorline", true, {})
vim.api.nvim_set_option_value("encoding", "utf-8", {})
vim.api.nvim_set_option_value("expandtab", true, {})
vim.api.nvim_set_option_value("fileencoding", "utf-8", {})
vim.api.nvim_set_option_value("fileencodings", "utf-8,sjis,cp932", {})
vim.api.nvim_set_option_value("fileformat", "unix", {})
vim.api.nvim_set_option_value("fileformats", "unix,dos", {})
vim.api.nvim_set_option_value("fillchars", "vert:\u{2502},fold:\u{ff65},eob:\u{20}", {})
vim.api.nvim_set_option_value("grepprg", "rg --vimgrep -uu --no-heading --smart-case", {})
vim.api.nvim_set_option_value("helplang", "ja,en", {})
vim.api.nvim_set_option_value("hidden", true, {})
vim.api.nvim_set_option_value("hlsearch", true, {})
vim.api.nvim_set_option_value("ignorecase", true, {})
vim.api.nvim_set_option_value("incsearch", true, {})
vim.api.nvim_set_option_value("laststatus", 3, {})
vim.api.nvim_set_option_value("list", true, {})
vim.api.nvim_set_option_value("number", true, {})
vim.api.nvim_set_option_value("pumblend", 5, {})
vim.api.nvim_set_option_value("pumheight", 10, {})
vim.api.nvim_set_option_value("relativenumber", false, {})
vim.api.nvim_set_option_value("scrolloff", 5, {})
vim.api.nvim_set_option_value("shiftwidth", 4, {})
vim.api.nvim_set_option_value("signcolumn", "number", {})
vim.api.nvim_set_option_value("smartcase", true, {})
vim.api.nvim_set_option_value("smartindent", true, {})
vim.api.nvim_set_option_value("smarttab", true, {})
vim.api.nvim_set_option_value("splitbelow", true, {})
vim.api.nvim_set_option_value("splitright", true, {})
vim.api.nvim_set_option_value("tabstop", 4, {})
vim.api.nvim_set_option_value("termguicolors", true, {})
vim.api.nvim_set_option_value("updatetime", 500, {})
vim.api.nvim_set_option_value("virtualedit", "block,onemore", {})
vim.api.nvim_set_option_value("wildmenu", true, {})
vim.api.nvim_set_option_value("wildmode", "longest,full", {})
vim.api.nvim_set_option_value("wildoptions", "pum", {})
vim.api.nvim_set_option_value("winblend", 10, {})

if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.api.nvim_set_option_value("shell", vim.fn.executable("pwsh") and "pwsh" or "powershell", {})
    vim.api.nvim_set_option_value(
        "shellcmdflag",
        "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSDefaultParameterValues['*:Encoding']='utf8';",
        {}
    )
    vim.api.nvim_set_option_value("shellpipe", '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode', {})
    vim.api.nvim_set_option_value("shellquote", "", {})
    vim.api.nvim_set_option_value("shellredir", '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode', {})
    vim.api.nvim_set_option_value("shellxquote", "", {})
end

-- keymap
vim.keymap.set("n", "<Esc><Esc>", function()
    vim.api.nvim_command("nohlsearch")
end, {})
vim.keymap.set("n", "<Leader>n", function()
    vim.api.nvim_command("setlocal relativenumber!")
end, {})
vim.keymap.set("n", "<C-k>", "<cmd>new +term<cr><cmd>resize 10<cr>", {})
vim.keymap.set("n", "<C-S-k>", "<cmd>tabnew +term<cr>", {})
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, {})

-- autocmd
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    command = "cwindow",
})
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(_)
        local win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value("number", false, { scope = "local", win = win_id })
        vim.api.nvim_set_option_value("relativenumber", false, { scope = "local", win = win_id })
        vim.cmd.startinsert()
    end,
})
vim.api.nvim_create_autocmd("TermClose", {
    callback = function(_)
        vim.api.nvim_input("<cr>")
    end,
})

-- command
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

-- other
vim.diagnostic.config({
    float = {
        border = "rounded",
    },
})

-- package
vim.cmd.packadd("termdebug")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    ui = {
        size = {
            width = 0.7,
            height = 0.7,
        },
        border = "rounded",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- colorscheme
if not vim.g.vscode then
    -- vim.cmd.colorscheme("chester")

    local lightline = vim.tbl_deep_extend("force", vim.api.nvim_get_var("lightline"), { colorscheme = "tokyonight" })
    vim.api.nvim_set_var("lightline", lightline)

    vim.cmd.colorscheme("tokyonight-storm")

    local colors = require("tokyonight.colors.storm")
    vim.api.nvim_set_hl(0, "Folded", { fg = vim.api.nvim_get_hl(0, { name = "Folded" }).fg, bg = nil })
    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green })
    vim.api.nvim_set_hl(0, "GitSignsDelte", { fg = colors.red })
end
