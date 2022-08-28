if empty(globpath(&runtimepath, "autoload/lightline.vim"))
    finish
endif

let s:colorscheme = empty(globpath(&rtp, "autoload/dracula.vim")) ? "default" : "dracula"

let g:lightline = {
            \ "colorscheme": s:colorscheme,
            \ }
