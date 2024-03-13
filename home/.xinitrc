#!/bin/sh

DefaultImModule=fcitx
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

GLFW_IM_MODULE=ibus

export DefaultImModule GTK_IM_MODULE QT_IM_MODULE XMODIFIERS GLFW_IM_MODULE

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrandr --output DisplayPort-0 --mode 1920x1080 --rate 360 --output DisplayPort-1 --mode 1920x1080 --rate 360 --rotate right --left-of DisplayPort-0

exec i3
