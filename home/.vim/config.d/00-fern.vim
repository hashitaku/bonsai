if empty(globpath(&runtimepath, "autoload/fern.vim"))
    finish
endif

let g:fern#drawer_width = 25
