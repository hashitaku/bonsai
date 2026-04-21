if executable("clang-format")
    def s:format_c_cpp(style: string)
        w
        system(printf("clang-format --style '%s' -i '%s'", style, expand("%:p")))
        e!
    enddef
    defcompile

    let s:style = {
    \   "BasedOnStyle": "Google",
    \   "AccessModifierOffset": -4,
    \   "AlignAfterOpenBracket": "Align",
    \   "AllowAllArgumentsOnNextLine": "true",
    \   "AllowAllParametersOfDeclarationOnNextLine": "true",
    \   "AllowShortFunctionsOnASingleLine": "true",
    \   "BinPackArguments": "false",
    \   "BinPackParameters": "false",
    \   "ColumnLimit": 80,
    \   "IncludeBlocks": "Preserve",
    \   "IndentPPDirectives": "BeforeHash",
    \   "IndentWidth": 4,
    \   "SpacesBeforeTrailingComments": 1
    \}

    augroup vimrc
        autocmd BufWritePre *.c,*.cc,*.cpp,*.h,*.hpp :call s:format_c_cpp(string(s:style))
    augroup end
endif
