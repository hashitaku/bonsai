if empty(globpath(&runtimepath, "autoload/lightline.vim"))
    finish
endif

let g:lightline = {
            \ "colorscheme": "one",
            \ }
