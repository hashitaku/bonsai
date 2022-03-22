#!/bin/bash

function is_capslock () {
    xset -q | sed -E 's/off|on/&\n/g' | grep Caps | grep -q on
}

function input_method () {
    method="$(dbus-send --session --print-reply=literal --dest=org.fcitx.Fcitx5 --type=method_call /controller org.fcitx.Fcitx.Controller1.CurrentInputMethod)"
    state="$(is_capslock && echo '  בּ')"

    if [[ "${method}" =~ 'mozc' ]]; then
        echo "あ${state}"
    else
        echo "en${state}"
    fi
}

function func () {
    input_method
    while true; do
        read -r _unused
        input_method
    done
}

dbus-monitor --session 'destination=org.fcitx.Fcitx5' | grep --line-buffered -E '65507|65509|65319|65322' | func
