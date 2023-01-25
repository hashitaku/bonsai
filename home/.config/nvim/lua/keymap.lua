vim.g.mapleader = ' '

--vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>Terminal
vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>Fern . -reveal=% -drawer -toggle<cr>', { noremap = true })

--[[
function _G.imap_tab()
    if vim.fn['pumvisible']() then
        return '<C-n>'
    elseif vim.fn['vsnip#jumpable'](1) then
        return '<Plug>(vsnip-jump-next)'
    else
        return '<Tab>'
    end
end

function _G.imap_stab()
    if vim.fn['pumvisible']() then
        return '<C-p>'
    elseif vim.fn['vsnip#jumpable'](-1) then
        return '<Plug>(vsnip-jump-prev)'
    else
        return '<Tab>'
    end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.imap_tab()', { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.imap_stab()', { expr = true, noremap = true })

local cmp = require('cmp')
vim.keymap.set('i', '<Tab>',
    function()
        if vim.fn['pumvisible']() then
            return 
        elseif vim.fn['vsnip#jumpable'](1) then
            return '<Plug>(vsnip-jump-next)'
        else
            return '<Tab>'
        end
    end,
    { expr = true, noremap = true }
)
]]
