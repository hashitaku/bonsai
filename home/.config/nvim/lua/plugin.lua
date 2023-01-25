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
    {
        'MunifTanjim/nui.nvim',
    },

    {
        'dracula/vim',
    },

    {
        'easymotion/vim-easymotion',
    },

    {
        'folke/noice.nvim',
        dependecies = {
            'MunifTanjim/nui.nvim'
        },
        opts = {
            message = {
                enabled = false,
            },
            preests = {
                command_palette = false,
            },
        },
    },

    {
        'hrsh7th/cmp-buffer',
    },

    {
        'hrsh7th/cmp-cmdline',
    },

    {
        'hrsh7th/cmp-nvim-lsp',
    },

    {
        'hrsh7th/cmp-path',
    },

    {
        'hrsh7th/cmp-vsnip',
    },

    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                --[[
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn['vsnip#jumpable'](1)
                            
                        else
                            fallback()
                        end
                    end,
                    ['<S-Tab>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                    ['<CR>'] = function(fallback)
                        if cmp.visible() then
                            cmp.confirm()
                        else
                            fallback()
                        end
                    end
                }),
                ]]
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        local max_width = 50

                        if vim_item.abbr:len() > max_width then
                            vim_item.abbr = vim_item.abbr:sub(0, max_width) .. '...'
                        end
                        return vim_item
                    end
                },
            })
        end,
    },

    {
        'hrsh7th/vim-vsnip',
        config = function()
            vim.g['vsnip_snippet_dir'] = vim.fn.stdpath('config') .. '/snippets'
        end,
    },

    {
        'itchyny/lightline.vim',
        config = function()
            vim.g['lightline'] = {
                colorscheme = 'dracula',
            }
        end,
    },

    {
        'lambdalisue/fern-git-status.vim',
        dependencies = {
            'lambdalisue/fern.vim',
        },
    },

    {
        'lambdalisue/fern-hijack.vim',
        dependencies = {
            'lambdalisue/fern.vim',
        },
    },

    {
        'lambdalisue/fern-renderer-nerdfont.vim',
        dependencies = {
            'lambdalisue/fern.vim',
        },
    },

    {
        'lambdalisue/fern.vim',
        config = function()
            vim.g['fern#default_hidden'] = true
            vim.g['fern#drawer_keep'] = true
            vim.g['fern#renderer#nerdfont#indent_markers'] = true
            vim.g['fern#renderer'] = 'nerdfont'
        end,
    },

    {
        'lambdalisue/nerdfont.vim',
    },

    {
        'neovim/nvim-lspconfig',
        config = function()
            require('lspconfig')['clangd'].setup({
                cmd = {
                    'clangd',
                    '--clang-tidy',
                    '--header-insertion=never',
                    '--malloc-trim',
                    '-j=2',
                },
            })

            vim.api.nvim_create_user_command('LspHover',
                function(args)
                    vim.lsp.buf.hover()
                end,
                {
                    nargs = '?',
                }
            )

            vim.opt['keywordprg'] = ':LspHover'
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                },
            })
        end,
    },

    {
        'rust-lang/rust.vim',
        ft = "rust",
        config = function()
            vim.g['rustfmt_autosave'] = true
        end,
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({})
        end,
    },
})
