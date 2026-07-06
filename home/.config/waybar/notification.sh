#!/bin/bash

paused=$(dunstctl is-paused)
if [ "$paused" = "true" ]; then
    echo '{"text":"","alt":"dnd","class":"dnd","tooltip":"Do Not Disturb"}'
    exit 0
fi

count=$(dunstctl count waiting)
if [ "$count" -gt 0 ]; then
    echo "{\"text\":\"$count\",\"alt\":\"notification\",\"class\":\"notification\",\"tooltip\":\"$count notifications\"}"
else
    echo '{"text":"","alt":"none","class":"none","tooltip":"No notifications"}'
fi
