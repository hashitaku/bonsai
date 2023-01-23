if !exists(":Termdebug")
    echoerr "config.d/00-termdebug.vim is not loading"
    finish
endif

let g:termdebug_config = {}
let g:termdebug_config['wide'] = 1
