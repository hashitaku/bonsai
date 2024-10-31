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
[ -f "${XDG_DATA_HOME}/cargo/env" ] && . "${XDG_DATA_HOME}/cargo/env"

# Go
GOPATH="${XDG_DATA_HOME}/go"
export GOPATH

# node.js
NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_USERCONFIG

# 野良ビルド用変数
[ -d "${HOME}/.local/bin" ] && PATH="${PATH}:${HOME}/.local/bin"
[ -d "${HOME}/.local/include" ] && CPATH="${CPATH}:${HOME}/.local/include"
[ -d "${HOME}/.local/lib" ] && LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/.local/lib"
[ -d "${HOME}/.local/lib64" ] && LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/local/lib64"
[ -d "${HOME}/.local/lib" ] && LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/.local/lib"
[ -d "${HOME}/.local/lib64" ] && LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/local/lib64"
export PATH CPATH LIBRARY_PATH LD_RUN_PATH

# linuxbrew
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# その他、環境変数
INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
GNUPGHOME="${XDG_DATA_HOME}/gnupg"
XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export INPUTRC GNUPGHOME XAUTHORITY

# bashrc
if [ -n "${BASH_VERSION}" ]; then
    if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
fi
