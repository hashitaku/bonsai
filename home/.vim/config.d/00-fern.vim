if empty(globpath(&runtimepath, "autoload/fern.vim"))
    finish
endif

let g:fern#drawer_keep = v:true

let g:fern#default_hidden = v:true

let g:fern#renderer = "nerdfont"
let g:fern#renderer#default#leading = "\u2502"
let g:fern#renderer#default#root_symbol = "\u252c\u2500 "
let g:fern#renderer#default#leaf_symbol = "\u251c\u2500 "
let g:fern#renderer#default#collapsed_symbol = "\u251c\u2500 "
let g:fern#renderer#default#expanded_symbol = "\u251c\u252c "
