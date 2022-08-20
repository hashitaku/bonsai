"function
def SetGuiHighlight(group: string, fg: string, bg: string = "chester_background", attr: string = "NONE")
    execute "hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg .. " gui=" .. attr
enddef

def SetCtermHighlight(group: string, fg: string, bg: string, attr: string = "NONE")
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
call SetGuiHighlight("Comment", "chester_comment", "chester_background", "italic")

call SetGuiHighlight("Constant", "chester_yellow")
call SetGuiHighlight("String", "chester_green")
call SetGuiHighlight("Character", "chester_green")
call SetGuiHighlight("Number", "chester_yellow")
call SetGuiHighlight("Boolean", "chester_yellow")
call SetGuiHighlight("Float", "chester_yellow")

call SetGuiHighlight("Identifier", "chester_red")
call SetGuiHighlight("Function", "chester_blue")

call SetGuiHighlight("Statement", "chester_cyan")
call SetGuiHighlight("Conditional", "chester_cyan")
call SetGuiHighlight("Repeat", "chester_cyan")
call SetGuiHighlight("Label", "chester_cyan")
call SetGuiHighlight("Operator", "chester_cyan")
call SetGuiHighlight("Keyword", "chester_cyan")
call SetGuiHighlight("Exeption", "chester_cyan")

call SetGuiHighlight("PreProc", "chester_cyan")
call SetGuiHighlight("Include", "chester_cyan")
call SetGuiHighlight("Define", "chester_cyan")
call SetGuiHighlight("Macro", "chester_cyan")
call SetGuiHighlight("PreCondit", "chester_cyan")

call SetGuiHighlight("Type", "chester_yellow")
call SetGuiHighlight("StorageClass", "chester_red_alt")
call SetGuiHighlight("Structure", "chester_red_alt")
call SetGuiHighlight("Typedef", "chester_cyan")

call SetGuiHighlight("Special", "chester_red")
call SetGuiHighlight("SpecialChar", "chester_red")
call SetGuiHighlight("Tag", "chester_red")
call SetGuiHighlight("Delimiter", "chester_red")
call SetGuiHighlight("SpecialComment", "chester_red")
call SetGuiHighlight("Debug", "chester_red")

call SetGuiHighlight("Underlined", "chester_foreground", "chester_background", "underline")

call SetGuiHighlight("Ignore", "chester_foreground")

call SetGuiHighlight("Error", "chester_foreground", "chester_red")

call SetGuiHighlight("Todo", "chester_foreground", "chester_yellow")

"highlight-groups
call SetGuiHighlight("ColorColumn", "NONE", "NONE")
call SetGuiHighlight("CursorColumn", "NONE", "NONE")
call SetGuiHighlight("CursorLine", "NONE", "chester_select")
call SetGuiHighlight("VertSplit", "chester_background", "chester_comment")
call SetGuiHighlight("LineNr", "chester_comment", "NONE", "bold")
call SetGuiHighlight("CursorLineNr", "chester_comment_alt", "NONE", "bold")

call SetGuiHighlight("StatusLine", "chester_foreground", "#3b444f", "bold")
hi StatusLine cterm=bold
call SetGuiHighlight("StatusLineNC", "chester_foreground", "#3b444f", "NONE")
hi StatusLineNC cterm=NONE

call SetCtermHighlight("CursorLine", "NONE", "NONE", "NONE")
call SetCtermHighlight("CursorLineNr", "NONE", "NONE", "NONE")

"call SetGuiHighlight("Normal", s:foreground, s:background)

if has('terminal')
    let g:terminal_ansi_colors = []
    for s:i in range(16)
        call add(g:terminal_ansi_colors, v:colornames["chester_" .. s:i])
    endfor
endif

" vim: sw=4
