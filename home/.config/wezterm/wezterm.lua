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

local config = wezterm.config_builder()

config.webgpu_power_preference = "HighPerformance"
config.front_end = "WebGpu"
config.default_prog = shell

config.initial_cols = 130
config.initial_rows = 30

config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = hide_tab_bar_if_only_one_tab
config.window_background_opacity = 1
config.window_decorations = "RESIZE"

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.window_frame = {
    font = wezterm.font_with_fallback({
        { family = "Inconsolata Nerd Font Mono", weight = "Regular" },

        { family = "Noto Sans Mono CJK JP",      weight = "Regular" },
    }),
    font_size = 10,
    active_titlebar_bg = "none",
    inactive_titlebar_bg = "none",
}

config.keys = {
    {
        key = "K",
        mods = "SHIFT|CTRL",
        action = wezterm.action.DisableDefaultAssignment,
    },
}
config.enable_kitty_keyboard = true

config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.animation_fps = 1

config.font = wezterm.font_with_fallback({
    { family = "Inconsolata Nerd Font Mono", weight = "Bold" },

    { family = "Noto Sans Mono CJK JP",      weight = "Bold" },
})
config.font_size = 14
config.bold_brightens_ansi_colors = true

config.colors = {
    foreground = "#f8f8f2",
    background = "#2c3643",
    cursor_bg = "#f8f8f2",
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

    tab_bar = {
        inactive_tab_edge = "none",
    },
}

local function change_font_size(window, pane)
    local font_range = {
        min = 14.0,
        max = 16.0,
    }
    local font_size_delta = 0.5

    local best_font_size = font_range.min
    local min_diff = window:get_dimensions().pixel_height - pane:get_dimensions().pixel_height
    for font_size = font_range.min, font_range.max, font_size_delta do
        local overrides = window:get_config_overrides() or {}

        overrides.font_size = font_size

        window:set_config_overrides(overrides)

        local current_diff = window:get_dimensions().pixel_height - pane:get_dimensions().pixel_height

        if current_diff < min_diff then
            min_diff = current_diff
            best_font_size = font_size
        end
    end

    local overrides = window:get_config_overrides() or {}

    overrides.font_size = best_font_size

    window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, pane)
    change_font_size(window, pane)
end)

return config
