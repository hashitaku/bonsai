DefaultImModule=fcitx
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

GLFW_IM_MODULE=ibus

export DefaultImModule GTK_IM_MODULE QT_IM_MODULE XMODIFIERS GLFW_IM_MODULE

eval $(dbus-launch --sh-syntax --exit-with-x11)

exec i3
