local options = {
    cursorline = true,
    encoding = "utf-8",
    expandtab = true,
    fileencoding = "utf-8",
    fileencodings = "utf-8,sjis",
    fileformat = "unix",
    fileformats = "unix,dos",
    fillchars = "vert:\u{2502},fold:\u{ff65},eob:\u{20}",
    helplang = "ja,en",
    hidden = true,
    hlsearch = true,
    ignorecase = true,
    incsearch = true,
    laststatus = 3,
    list = true,
    number = true,
    pumblend = 5,
    pumheight = 10,
    relativenumber = false,
    shiftwidth = 4,
    signcolumn = "number",
    smartcase = true,
    smartindent = true,
    smarttab = true,
    splitbelow = true,
    splitright = true,
    tabstop = 4,
    termguicolors = true,
    updatetime = 500,
    virtualedit = "block,onemore",
    wildmenu = true,
    wildmode = "longest,full",
    wildoptions = "pum",
    grepprg = "rg --vimgrep --no-heading",
    cmdheight = 0,
}

if vim.loop.os_uname().sysname == "Windows_NT" then
    options.shell = vim.fn.executable("pwsh") and "pwsh" or "powershell"
    options.shellcmdflag =
        "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSDefaultParameterValues['*:Encoding']='utf8';"
    options.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    options.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
    options.shellquote = ""
    options.shellxquote = ""
end

-- https://github.com/vscode-neovim/vscode-neovim/issues/1369
if not vim.vscode then
    options.winblend = 10
end

vim.g.mapleader = " "

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- keymap
vim.keymap.set("n", "<Esc><Esc>", function()
    vim.api.nvim_command("nohlsearch")
end, {})
vim.keymap.set("n", "<Leader>n", function()
    vim.api.nvim_command("setlocal relativenumber!")
end, {})
vim.keymap.set("n", "<C-k>", "<cmd>tabnew +term<cr>", {})

-- autocmd
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    command = "cwindow",
})
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(_)
        vim.cmd("startinsert")
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})
vim.api.nvim_create_autocmd("TermClose", {
    callback = function(_)
        vim.api.nvim_input("<cr>")
    end,
})

vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
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

require("lazy").setup("plugin", {
    ui = {
        size = {
            width = 0.7,
            height = 0.7,
        },
        border = "rounded",
    },
})

if not vim.g.vscode then
    --vim.cmd.colorscheme("chester")
    vim.cmd.colorscheme("tokyonight")
    vim.cmd.highlight("Folded None")
end
