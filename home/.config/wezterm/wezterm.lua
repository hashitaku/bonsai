local wezterm = require "wezterm"

local target = wezterm.target_triple

local window_decorations
if target == "x86_64-unknown-linux-gnu" then
    window_decorations = "RESIZE"
elseif target == "x86_64-pc-windows-msvc" then
    window_decorations = "TITLE | RESIZE"
end

return {
    default_prog = { "powershell" },
    
    initial_cols = 120,
    initial_rows = 30,

    hide_tab_bar_if_only_one_tab = true,
    window_decorations = window_decorations,
    window_padding = {
        left = 0,
        right = 0,
        top =  0,
        bottom = 0,
    },

    default_cursor_style = "BlinkingUnderline",
    cursor_blink_rate = 500,
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    animation_fps = 1,

    --font = wezterm.font("Consolas", { weight = "Bold"}),
    font = wezterm.font("Ubuntu Mono", { weight = "Bold"}),
    font_size = 14.0,

    colors = {
        foreground = "#f8f8f2",
        background = "#2c3643",
        --cursor_fg = "#ffffff",
        cursor_bg = "#ffffff",
        selection_bg = "#222a34",

        ansi = {
            "#666666",
            "#fa5e5b",
            "#16c98d",
            "#ffc83f",
            "#288ad6",
            "#b267e6",
            "#89bde4",
            "#f8f8f2",
        },

        brights = {
            "#888888",
            "#ff708e",
            "#79c9af",
            "#ffe299",
            "#81b1d6",
            "#bf8ae6",
            "#b6cfe3",
            "#f8f8f0",
        },
    },
}