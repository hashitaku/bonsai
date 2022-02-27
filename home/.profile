if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Rust
. ~/.cargo/env

# 野良ビルド用変数
PATH="${PATH}:${HOME}/local/bin"
CPATH="${CPATH}:${HOME}/local/include"
LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/local/lib:${HOME}/local/lib64"
LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/local/lib:${HOME}/local/lib64"

# linuxbrew用変数
PATH="${PATH}:${HOME}/.linuxbrew/bin:${HOME}/.linuxbrew/opt"
CPATH="${CPATH}:${HOME}/.linuxbrew/include"
LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/.linuxbrew/lib"
LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/.linuxbrew/lib"

# cuda用変数
PATH="${PATH}:/usr/local/cuda/bin"
CPATH="${CPATH}:/usr/local/cuda/include"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64"
LIBRARY_PATH="${LIBRARY_PATH}:/usr/local/cuda/lib64"

export PATH CPATH LIBRARY_PATH LD_RUN_PATH LD_LIBRARY_PATH

if [ -n "$BASH_VERSION" ]; then
	if [ -f "${HOME}/.bashrc" ]; then
		. "${HOME}/.bashrc"
	fi
fi
