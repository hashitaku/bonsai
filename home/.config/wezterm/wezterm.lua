local wezterm = require("wezterm")

local target = wezterm.target_triple

local shell
local hide_tab_bar_if_only_one_tab
if target == "x86_64-unknown-linux-gnu" then
    shell = {
        "bash",
    }
    hide_tab_bar_if_only_one_tab = true
elseif target == "x86_64-pc-windows-msvc" then
    shell = {
        "pwsh",
        "-NoLogo",
    }
    hide_tab_bar_if_only_one_tab = false
end

return {
    webgpu_power_preference = "HighPerformance",
    front_end = "WebGpu",
    default_prog = shell,

    initial_cols = 130,
    initial_rows = 30,

    hide_tab_bar_if_only_one_tab = hide_tab_bar_if_only_one_tab,
    window_background_opacity = 0.95,
    window_decorations = "RESIZE",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    window_frame = {
        font = wezterm.font({
            family = "Noto Sans Mono CJK JP",
            weight = "Bold"
        }),
        font_size = 8,
    },

    default_cursor_style = "BlinkingUnderline",
    cursor_blink_rate = 500,
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    animation_fps = 1,

    font = wezterm.font_with_fallback({
        { family = "InconsolataGo Nerd Font Mono", weight = "Bold" },
        --{ family = "UbuntuMono Nerd Font", weight = "Bold" },

        { family = "Noto Sans Mono CJK JP", weight = "Bold" },
    }),
    font_size = 14,
    bold_brightens_ansi_colors = true,

    colors = {
        foreground = "#f8f8f2",
        background = "#2c3643",
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
