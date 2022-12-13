"init
highlight clear Normal
set background=dark
highlight clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "chester"

"colors
runtime colors/lists/chestercolors.vim

"group-name
hi Comment        guifg=chester_comment    guibg=NONE gui=italic

hi Constant       guifg=chester_yellow     guibg=NONE gui=NONE
hi String         guifg=chester_green      guibg=NONE gui=NONE
hi Character      guifg=chester_green      guibg=NONE gui=NONE
hi Number         guifg=chester_yellow     guibg=NONE gui=NONE
hi Boolean        guifg=chester_yellow     guibg=NONE gui=NONE
hi Float          guifg=chester_yellow     guibg=NONE gui=NONE

hi Identifier     guifg=chester_red        guibg=NONE gui=NONE
hi Function       guifg=chester_blue       guibg=NONE gui=NONE

hi Statement      guifg=chester_cyan       guibg=NONE gui=NONE
hi Conditional    guifg=chester_cyan       guibg=NONE gui=NONE
hi Repeat         guifg=chester_cyan       guibg=NONE gui=NONE
hi Label          guifg=chester_cyan       guibg=NONE gui=NONE
hi Operator       guifg=chester_cyan       guibg=NONE gui=NONE
hi Keyword        guifg=chester_cyan       guibg=NONE gui=NONE
hi Exeption       guifg=chester_cyan       guibg=NONE gui=NONE

hi PreProc        guifg=chester_cyan       guibg=NONE gui=NONE
hi Include        guifg=chester_cyan       guibg=NONE gui=NONE
hi Define         guifg=chester_cyan       guibg=NONE gui=NONE
hi Macro          guifg=chester_cyan       guibg=NONE gui=NONE
hi PreConditit    guifg=chester_cyan       guibg=NONE gui=NONE

hi Type           guifg=chester_yellow     guibg=NONE gui=NONE
hi StorageClass   guifg=chester_red_alt    guibg=NONE gui=NONE
hi Structure      guifg=chester_red_alt    guibg=NONE gui=NONE
hi Typedef        guifg=chester_cyan       guibg=NONE gui=NONE

hi Special        guifg=chester_red        guibg=NONE gui=NONE
hi SpecialChar    guifg=chester_red        guibg=NONE gui=NONE
hi Tab            guifg=chester_red        guibg=NONE gui=NONE
hi Delimiter      guifg=chester_red        guibg=NONE gui=NONE
hi SpecialComment guifg=chester_red        guibg=NONE gui=NONE
hi Debug          guifg=chester_red        guibg=NONE gui=NONE

hi Underline      guifg=chester_foreground guibg=NONE gui=underline

hi Ignore         guifg=chester_foreground guibg=NONE gui=underline

hi Todo           guifg=NONE               guibg=NONE gui=undercurl guisp=chester_yellow

"highlight-groups
hi ColorColumn guifg=NONE guibg=chester_select gui=NONE
"hi Conceal guifg= guibg= gui=
hi Cursor guifg=NONE guibg=chester_comment gui=NONE
hi lCursor guifg=bg guibg=fg gui=NONE
hi CursorIM guifg=bg guibg=fg gui=NONE
hi CursorColumn guifg=NONE guibg=chester_select gui=NONE
hi CursorLine guifg=NONE guibg=chester_select gui=NONE
hi Directory guifg=chester_blue guibg=NONE gui=NONE
hi DiffAdd guifg=NONE guibg=chester_blend_green gui=NONE
hi DiffChange guifg=NONE guibg=chester_blend_green gui=NONE
hi DiffDelete guifg=NONE guibg=chester_blend_red gui=NONE
hi DiffText guifg=NONE guibg=chester_blend_green_alt gui=NONE
hi link EndOfBuffer NonText
hi ErrorMsg guifg=chester_red guibg=NONE gui=NONE
hi VertSplit guifg=chester_comment guibg=NONE gui=NONE
"hi Folded guifg= guibg= gui=
"hi FoldColumn guifg= guibg= gui=
hi SignColumn guifg=fg guibg=NONE gui=NONE
hi link IncSearch Search
hi LineNr guifg=chester_comment guibg=NONE gui=bold
hi link LineNrAbove LineNr
hi link LineNrBelow LineNr
hi CursorLineNr guifg=chester_comment_alt guibg=NONE gui=bold
"hi link CursorLineSign SignColumn
"hi link CursorLineFold FoldedColumn
hi MatchParen guifg=NONE guibg=NONE gui=underline
"hi ModeMsg guifg= guibg= gui=
"hi MoreMsg guifg= guibg= gui=
"hi NonText guifg= guibg= gui=
hi Normal guifg=chester_foreground guibg=chester_background
hi Pmenu guifg=NONE guibg=chester_background_alt gui=NONE
"hi Pmenusel guifg=NONE guibg=NONE gui=NONE
"hi PmenuSbar guifg=NONE guibg= gui=NONE
"hi PmenuThumb guifg=NONE guibg= gui=NONE
"hi Question guifg= guibg= gui=
"hi QuickFixLine guifg= guibg= gui=
hi Search guifg=NONE guibg=chester_select gui=NONE
"hi CurSearch guifg= guibg= gui=
"hi SpecialKey guifg= guibg= gui=
"hi SpellBad guifg= guibg= gui=
"hi SpellCap guifg= guibg= gui=
"hi SpellLocal guifg= guibg= gui=
"hi SpellRare guifg= guibg= gui=
"hi StatusLine guifg= guibg= gui=
"hi StatusLineNC guifg= guibg= gui=
"hi StatusLineTerm guifg= guibg= gui=
"hi StatusLineTermNC guifg= guibg= gui=
"hi TabLine guifg= guibg= gui=
"hi TabLineFill guifg= guibg= gui=
"hi TabLineSel guifg= guibg= gui=
hi Terminal guifg=chester_foreground guibg=chester_background gui=NONE
"hi Title guifg= guibg= gui=
hi Visual guifg=NONE guibg=chester_select gui=NONE
hi link VisualNOS Visual
"hi WarningMsg guifg= guibg= gui=
"hi WildMenu guifg= guibg= gui=

hi CursorLine ctermfg=NONE ctermbg=NONE cterm=NONE
hi VertSplit ctermfg=NONE ctermbg=NONE cterm=NONE
hi CursorLineNr ctermfg=NONE ctermbg=NONE cterm=NONE

"plugins
hi debugPC guifg=NONE guibg=chester_background_alt
hi debugBreakpoint guifg=chester_red

hi link lspInlayHintsParameter Comment
hi link lspInlayHintsType Comment

hi link FernIndentMarkers Comment

if has('terminal')
    let g:terminal_ansi_colors = []
    for s:i in range(16)
        call add(g:terminal_ansi_colors, v:colornames["chester_" .. s:i])
    endfor
endif

" vim: sw=4
