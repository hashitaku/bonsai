"function
def s:SetGuiHighlight(group: string, fg: string, bg: string = "chester_background", attr: string = "NONE")
    execute "hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg .. " gui=" .. attr
enddef

def s:SetCtermHighlight(group: string, fg: string, bg: string, attr: string = "NONE")
    execute "hi " .. group .. " ctermfg=" .. fg .. " ctermbg=" .. bg .. " cterm=" .. attr
enddef

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
call s:SetGuiHighlight("Comment", "chester_comment", "chester_background", "italic")

call s:SetGuiHighlight("Constant", "chester_yellow")
call s:SetGuiHighlight("String", "chester_green")
call s:SetGuiHighlight("Character", "chester_green")
call s:SetGuiHighlight("Number", "chester_yellow")
call s:SetGuiHighlight("Boolean", "chester_yellow")
call s:SetGuiHighlight("Float", "chester_yellow")

call s:SetGuiHighlight("Identifier", "chester_red")
call s:SetGuiHighlight("Function", "chester_blue")

call s:SetGuiHighlight("Statement", "chester_cyan")
call s:SetGuiHighlight("Conditional", "chester_cyan")
call s:SetGuiHighlight("Repeat", "chester_cyan")
call s:SetGuiHighlight("Label", "chester_cyan")
call s:SetGuiHighlight("Operator", "chester_cyan")
call s:SetGuiHighlight("Keyword", "chester_cyan")
call s:SetGuiHighlight("Exeption", "chester_cyan")

call s:SetGuiHighlight("PreProc", "chester_cyan")
call s:SetGuiHighlight("Include", "chester_cyan")
call s:SetGuiHighlight("Define", "chester_cyan")
call s:SetGuiHighlight("Macro", "chester_cyan")
call s:SetGuiHighlight("PreCondit", "chester_cyan")

call s:SetGuiHighlight("Type", "chester_yellow")
call s:SetGuiHighlight("StorageClass", "chester_red_alt")
call s:SetGuiHighlight("Structure", "chester_red_alt")
call s:SetGuiHighlight("Typedef", "chester_cyan")

call s:SetGuiHighlight("Special", "chester_red")
call s:SetGuiHighlight("SpecialChar", "chester_red")
call s:SetGuiHighlight("Tag", "chester_red")
call s:SetGuiHighlight("Delimiter", "chester_red")
call s:SetGuiHighlight("SpecialComment", "chester_red")
call s:SetGuiHighlight("Debug", "chester_red")

call s:SetGuiHighlight("Underlined", "chester_foreground", "chester_background", "underline")

call s:SetGuiHighlight("Ignore", "chester_foreground")

call s:SetGuiHighlight("Error", "chester_foreground", "chester_red")

call s:SetGuiHighlight("Todo", "chester_foreground", "chester_yellow")

"highlight-groups
call s:SetGuiHighlight("ColorColumn", "NONE", "NONE")
call s:SetGuiHighlight("CursorColumn", "NONE", "NONE")
call s:SetGuiHighlight("CursorLine", "NONE", "chester_select")
call s:SetGuiHighlight("VertSplit", "chester_comment", "chester_background", "NONE")
call s:SetCtermHighlight("VertSplit", "NONE", "NONE", "NONE")
call s:SetGuiHighlight("LineNr", "chester_comment", "NONE", "bold")
call s:SetGuiHighlight("CursorLineNr", "chester_comment_alt", "NONE", "bold")

call s:SetGuiHighlight("StatusLine", "chester_foreground", "#3b444f", "bold")
hi StatusLine cterm=bold
call s:SetGuiHighlight("StatusLineNC", "chester_foreground", "#3b444f", "NONE")
hi StatusLineNC cterm=NONE

call s:SetCtermHighlight("CursorLine", "NONE", "NONE", "NONE")
call s:SetCtermHighlight("CursorLineNr", "NONE", "NONE", "NONE")

call s:SetGuiHighlight("Normal", "chester_foreground", "chester_background")

hi Pmenu guibg=#3F4D5E

if has('terminal')
    let g:terminal_ansi_colors = []
    for s:i in range(16)
        call add(g:terminal_ansi_colors, v:colornames["chester_" .. s:i])
    endfor
endif

" vim: sw=4
