if empty(globpath(&runtimepath, "autoload/rainbow.vim"))
    finish
endif

let g:rainbow_active = 1

let g:rainbow_conf = {
\   "guifgs": ["Gold", "Orchid", "LightSkyBlue"],
\   "operators": "",
\} 
