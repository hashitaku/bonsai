return {
    {
        'MunifTanjim/nui.nvim',
    },

    {
        'easymotion/vim-easymotion',
    },

    {
        'folke/noice.nvim',
        dependencies = {
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
        'folke/tokyonight.nvim',
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
                    completion = {
                        border = 'rounded',
                        col_offset = 0,
                        scrollbar = false,
                        scrolloff = 0,
                        side_padding = 1,
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None',
                    },
                    documentation = {
                        border = 'rounded',
                        col_offset = 0,
                        scrollbar = false,
                        scrolloff = 0,
                        side_padding = 1,
                        winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:CursorLine,Search:None',
                    },
                    --completion = cmp.config.window.bordered(),
                    --documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn['vsnip#jumpable'](1) == 1 then
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-next)', true, true, true), '', false)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '', false)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),

                    ['<CR>'] = function(fallback)
                        if cmp.visible() then
                            cmp.confirm()
                        else
                            fallback()
                        end
                    end
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'path' },
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
                colorscheme = 'one',

                separator            = { left = '\u{E0B4}', right = '\u{E0B6}' },
                subseparator         = { left = '\u{E0B5}', right = '\u{E0B7}' },
                tabline_separator    = { left = '\u{E0B4}', right = '\u{E0B6}' },
                tabline_subseparator = { left = '\u{E0B5}', right = '\u{E0B7}' },

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
            vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>Fern . -reveal=% -drawer -toggle<cr>', { noremap = true })
        end,
    },

    {
        'lambdalisue/nerdfont.vim',
    },

    {
        'neovim/nvim-lspconfig',
        config = function()
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

            vim.api.nvim_create_user_command('LspHover',
                function(args)
                    vim.lsp.buf.hover()
                end,
                {
                    nargs = '?',
                }
            )

            vim.opt['keywordprg'] = ':LspHover'

            require('lspconfig')['clangd'].setup({
                cmd = {
                    'clangd',
                    '--clang-tidy',
                    '--header-insertion=never',
                    '--malloc-trim',
                    '-j=2',
                },
                handlers = vim.lsp.handlers,
            })

            require('lspconfig')['rust_analyzer'].setup({
                handlers = vim.lsp.handlers,
            })
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'bash',
                    'c',
                    'cmake',
                    'cpp',
                    'help',
                    'json',
                    'lua',
                    'make',
                    'markdown',
                    'markdown_inline',
                    'meson',
                    'python',
                    'regex',
                    'rust',
                    'vim',
                },
                sync_intall = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    },

    {
        'nvim-treesitter/playground',
    },

    {
        'rust-lang/rust.vim',
        ft = 'rust',
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

    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup({
                char = '',
                show_current_context = true,
                --use_treesitter = true,
                --show_current_context_start = true,
            })
        end,
    },

    {
        'hashitaku/chester.nvim',
    },

    {
        'akinsho/toggleterm.nvim',
        config = function()
            require('toggleterm').setup({})
        end,
    },
}
