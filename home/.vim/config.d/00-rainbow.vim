if !jetpack#tap("rainbow")
    echoerr "config.d/00-rainbow.vim is not loading"
    finish
endif

let g:rainbow_active = 1

let g:rainbow_conf = {
\   "guifgs": ["Gold", "Orchid", "LightSkyBlue"],
\   "operators": "",
\} 
