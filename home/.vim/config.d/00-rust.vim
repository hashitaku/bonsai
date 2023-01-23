if !jetpack#tap("rust.vim")
    echoerr "config.d/00-rust.vim is not loading"
    finish
endif

let g:rustfmt_autosave = 1
