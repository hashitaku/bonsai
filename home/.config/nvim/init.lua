local options = {
    cursorline = true,
    encoding = 'utf-8',
    fillchars = 'vert:\u{2502},fold:-,eob:\u{20}',
    hidden = true,
    hlsearch = true,
    ignorecase = true,
    incsearch = true,
    laststatus = 3,
    number = true,
    pumheight = 10,
    shiftwidth = 4,
    signcolumn = 'number',
    smartcase = true,
    smartindent = true,
    smarttab = true,
    splitbelow = true,
    splitright = true,
    termguicolors = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.api.nvim_command('colorscheme habamax')
vim.g.mapleader = ' '
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#renderer#nerdfont#indent_markers'] = true

vim.api.nvim_command('packadd termdebug')

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

require('lazy').setup({
    {'easymotion/vim-easymotion'},
    {'itchyny/lightline.vim'},
    {'lambdalisue/fern-git-status.vim', dependencies = {'lambdalisue/fern.vim'}},
    {'lambdalisue/fern-hijack.vim', dependencies = {'lambdalisue/fern.vim'}},
    {'lambdalisue/fern-renderer-nerdfont.vim', dependencies = {'lambdalisue/fern.vim'}},
    {'lambdalisue/fern.vim'},
    {'lambdalisue/nerdfont.vim'},
    {'rust-lang/rust.vim'},
    {'nvim-treesitter/nvim-treesitter'}
})

require('nvim-treesitter.configs').setup({
    highlight = {
	enable = true,
    },
})
require('keymap')
