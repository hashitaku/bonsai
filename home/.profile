# Rust
[ -f "${HOME}/.cargo/env" ] && . ~/.cargo/env

# 野良ビルド用変数
PATH="${PATH}:${HOME}/local/bin"
CPATH="${CPATH}:${HOME}/local/include"
LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/local/lib:${HOME}/local/lib64"
LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/local/lib:${HOME}/local/lib64"

export PATH CPATH LIBRARY_PATH LD_RUN_PATH

# xdg base directory
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME

if [ -n "$BASH_VERSION" ]; then
	if [ -f "${HOME}/.bashrc" ]; then
		. "${HOME}/.bashrc"
	fi
fi
