let s:keepcpo = &cpo
set cpo&vim

call extend(v:colornames, {
\   "chester_foreground"     : "#e0e0e0",
\   "chester_background"     : "#2c3643",
\   "chester_background_alt" : "#3f4d5e",
\   "chester_select"         : "#222a34",
\   "chester_comment"        : "#99a9b3",
\   "chester_comment_alt"    : "#c6c6c6",
\
\   "chester_black"       : "#666666",
\   "chester_black_alt"   : "#888888",
\   "chester_red"         : "#fa5e5b",
\   "chester_red_alt"     : "#ff708e",
\   "chester_green"       : "#16c98d",
\   "chester_green_alt"   : "#79c9af",
\   "chester_yellow"      : "#ffc83f",
\   "chester_yellow_alt"  : "#ffe299",
\   "chester_blue"        : "#288ad6",
\   "chester_blue_alt"    : "#81b1d6",
\   "chester_magenta"     : "#b267e6",
\   "chester_magenta_alt" : "#bf8ae6",
\   "chester_cyan"        : "#89bde4",
\   "chester_cyan_alt"    : "#b6cfe3",
\   "chester_white"       : "#f8f8f2",
\   "chester_white_alt"   : "#f8f8f0",
\
\   "chester_blend_red"         : "#934a4f",
\   "chester_blend_red_alt"     : "#955368",
\   "chester_blend_green"       : "#217f68",
\   "chester_blend_green_alt"   : "#527f79",
\   "chester_blend_yellow"      : "#957f41",
\   "chester_blend_yellow_alt"  : "#958c6e",
\   "chester_blend_magenta"     : "#6f4e94",
\   "chester_blend_magenta_alt" : "#756094",
\   "chester_blend_cyan"        : "#5a7993",
\   "chester_blend_cyan_alt"    : "#718293",
\
\   "chester_0"  : "#666666",
\   "chester_1"  : "#fa5e5b",
\   "chester_2"  : "#16c98d",
\   "chester_3"  : "#ffc83f",
\   "chester_4"  : "#288ad6",
\   "chester_5"  : "#b267e6",
\   "chester_6"  : "#89bde4",
\   "chester_7"  : "#f8f8f2",
\   "chester_8"  : "#888888",
\   "chester_9"  : "#ff708e",
\   "chester_10" : "#79c9af",
\   "chester_11" : "#ffe299",
\   "chester_12" : "#81b1d6",
\   "chester_13" : "#bf8ae6",
\   "chester_14" : "#b6cfe3",
\   "chester_15" : "#f8f8f0",
\
\   }, "keep")

let &cpo = s:keepcpo
unlet s:keepcpo
