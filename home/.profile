# xdg base directory
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

# Rust
CARGO_HOME="${XDG_DATA_HOME}/cargo"
RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME RUSTUP_HOME
PATH="${PATH}:${CARGO_HOME}/bin"
export PATH

# Go
GOPATH="${XDG_DATA_HOME}/go"
export GOPATH

# node.js
NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_USERCONFIG
PATH="${PATH}:$(npm prefix --global)/bin"
export PATH

# bun
BUN_INSTALL="${XDG_DATA_HOME}/bun"
PATH="${PATH}:${BUN_INSTALL}/bin"
export BUN_INSTALL PATH

# Dotnet
PATH="${PATH}:${HOME}/.dotnet/tools"
export PATH

# Azure
AZURE_CONFIG_DIR="${XDG_DATA_HOME}/azure"
export AZURE_CONFIG_DIR

# 野良ビルド用変数
[ -d "${HOME}/.local/bin" ] && PATH="${PATH}:${HOME}/.local/bin"
[ -d "${HOME}/.local/include" ] && CPATH="${CPATH}:${HOME}/.local/include"
[ -d "${HOME}/.local/lib" ] && LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/.local/lib"
[ -d "${HOME}/.local/lib64" ] && LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/local/lib64"
[ -d "${HOME}/.local/lib" ] && LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/.local/lib"
[ -d "${HOME}/.local/lib64" ] && LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/local/lib64"
export PATH CPATH LIBRARY_PATH LD_RUN_PATH

# その他、環境変数
INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
GNUPGHOME="${XDG_DATA_HOME}/gnupg"
XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export INPUTRC GNUPGHOME XAUTHORITY

# WSL用設定
if [ "$(systemd-detect-virt)" = 'wsl' ]; then
    if [ ! -L /run/user/$(id -u)/wayland-0 ]; then
        ln -sf /mnt/wslg/runtime-dir/wayland-0 /run/user/$(id -u)/wayland-0
        ln -sf /mnt/wslg/runtime-dir/wayland-0.lock /run/user/$(id -u)/wayland-0.lock
    fi

    # WSLgでWaylandがあまりうまく動作しないためXを使用
    unset WAYLAND_DISPLAY

    LANG=ja_JP.UTF-8
    LC_ALL=ja_JP.UTF-8
    export LANG LC_ALL

    DefaultImModule=fcitx
    GTK_IM_MODULE=fcitx
    QT_IM_MODULE=fcitx
    XMODIFIERS=@im=fcitx
    GLFW_IM_MODULE=ibus
    export DefaultImModule GTK_IM_MODULE QT_IM_MODULE XMODIFIERS GLFW_IM_MODULE
fi

# bashrc
if [ -n "${BASH_VERSION}" ]; then
    if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi
