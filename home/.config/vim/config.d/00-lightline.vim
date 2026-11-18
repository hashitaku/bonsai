if !jetpack#tap("lightline.vim")
    echoerr "config.d/00-lightline.vim is not loading"
    finish
endif

let g:lightline = {
\   "colorscheme": "one",
\
\   "active": {
\       "left": [
\           ["mode", "paste"],
\           ["readonly", "filename", "modified"],
\       ],
\       "right": [
\           ["lineinfo"],
\           ["percent"],
\           ["fileformat", "fileencoding", "filetype"],
\       ],
\   },
\
\   "inactive": {
\   },
\
\   "tabline": {
\   },
\}
