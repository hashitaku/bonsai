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
-- nightly build
-- config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = false
config.tab_max_width = 20
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

        { family = "Noto Sans Mono CJK JP", weight = "Regular" },
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

    { family = "Noto Sans Mono CJK JP", weight = "Bold" },
})
config.font_size = 14
config.bold_brightens_ansi_colors = true

config.colors = {
    foreground = "#c0caf5",
    background = "#24283b",
    cursor_bg = "#c0caf5",
    cursor_border = "#c0caf5",
    cursor_fg = "#24283b",
    selection_bg = "#2e3c64",
    selection_fg = "#c0caf5",
    split = "#7aa2f7",
    compose_cursor = "#ff9e64",
    scrollbar_thumb = "#292e42",

    ansi = {
        "#1d202f",
        "#f7768e",
        "#9ece6a",
        "#e0af68",
        "#7aa2f7",
        "#bb9af7",
        "#7dcfff",
        "#a9b1d6",
    },
    brights = {
        "#414868",
        "#f7768e",
        "#9ece6a",
        "#e0af68",
        "#7aa2f7",
        "#bb9af7",
        "#7dcfff",
        "#c0caf5",
    },

    --[[
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
    ]]

    tab_bar = {
        background = "#1E2030",
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

local function update_right_status(window, pane)
    local datetime = wezterm.strftime("%Y-%m-%d %H:%M:%S")

    local fmt = wezterm.format({
        { Foreground = { Color = "#3B4261" } },
        { Text = "" },
        { Attribute = { Italic = true } },
        { Foreground = { Color = "#82AAFF" } },
        { Background = { Color = "#3B4261" } },
        { Text = " " .. datetime .. " " },
    })

    window:set_right_status(fmt)
end

wezterm.on("window-resized", function(window, pane)
    change_font_size(window, pane)
end)

wezterm.on("update-status", function(window, pane)
    update_right_status(window, pane)
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local active_fg = "#82AAFF"
    local active_bg = "#3B4261"
    local inactive_fg = "#545C7E"
    local inactive_bg = "#2F334D"
    local tabbar_bg = "#1E2030"

    local pane_title = tab.active_pane.title
    if #pane_title > 14 then
        pane_title = pane_title:sub(1, 12) .. ".."
    end
    local content = string.format("%d %s", tab.tab_index + 1, pane_title)
    if content:sub(1, 1) ~= " " then
        content = " " .. content
    end

    if content:sub(#content, #content) ~= " " then
        content = content .. " "
    end

    local content_fg, content_bg
    if tab.is_active then
        content_fg = active_fg
        content_bg = active_bg
    else
        content_fg = inactive_fg
        content_bg = inactive_bg
    end

    local right_separator, right_separator_fg, right_separator_bg
    if tab.is_active then
        right_separator = ""
        right_separator_fg = active_bg -- 色反転

        -- アクティブタブが最後のタブであるときはタブバーの背景色にする
        if tab.tab_index + 1 == #tabs then
            right_separator_bg = tabbar_bg
        else
            right_separator_bg = inactive_bg
        end
    else
        -- インアクティブタブが最後でなく次のタブがアクティブではない時
        if (tab.tab_index + 1 ~= #tabs) and not tabs[tab.tab_index + 2].is_active then
            right_separator = ""
            right_separator_fg = inactive_fg
            right_separator_bg = inactive_bg
        else
            right_separator = ""
            right_separator_fg = inactive_bg -- 色反転
            -- アクティブタブが最後のタブであるときはタブバーの背景色にする
            if tab.tab_index + 1 == #tabs then
                right_separator_bg = tabbar_bg
            else
                -- 次のタブがアクティブタブの時の背景色はアクティブタブの背景色
                right_separator_bg = active_bg
            end
        end
    end

    return {
        { Foreground = { Color = "none" } },
        { Background = { Color = "none" } },
        { Text = "" },
        { Foreground = { Color = content_fg } },
        { Background = { Color = content_bg } },
        { Text = content },
        { Foreground = { Color = right_separator_fg } },
        { Background = { Color = right_separator_bg } },
        { Text = right_separator },
    }
end)

return config
