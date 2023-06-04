#!/bin/bash

is_mute="$(pactl -f json list sources 2>/dev/null | jq -r --arg default "$(pactl get-default-source)" '.[] | select(.name == $default).mute')"

if $is_mute; then
    echo " muted"
    #return 1
else
    echo -n " "
    pactl -f json list sources 2>/dev/null | jq -r --arg default "$(pactl get-default-source)" '.[] | select(.name == $default).volume | map(.value_percent) | join(",")'
fi
