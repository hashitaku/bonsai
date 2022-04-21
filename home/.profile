# Rust
[ -f "${HOME}/.cargo/env" ] && . ~/.cargo/env

# 野良ビルド用変数
PATH="${PATH}:${HOME}/local/bin"
CPATH="${CPATH}:${HOME}/local/include"
LD_RUN_PATH="${LD_RUN_PATH}:${HOME}/local/lib:${HOME}/local/lib64"
LIBRARY_PATH="${LIBRARY_PATH}:${HOME}/local/lib:${HOME}/local/lib64"

# cuda用変数
PATH="${PATH}:/opt/cuda/bin"
CPATH="${CPATH}:/opt/cuda/include"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/cuda/lib64"
LIBRARY_PATH="${LIBRARY_PATH}:/usr/local/cuda/lib64"

export PATH CPATH LIBRARY_PATH LD_RUN_PATH LD_LIBRARY_PATH

if [ -n "$BASH_VERSION" ]; then
	if [ -f "${HOME}/.bashrc" ]; then
		. "${HOME}/.bashrc"
	fi
fi
