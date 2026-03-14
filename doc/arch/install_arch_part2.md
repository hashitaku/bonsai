# 設定項目の入力

```sh
#!/bin/bash -eu

XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
```

# 初期設定

## AURヘルパーのインストール

```sh
cd ~
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si --noconfirm
cd ~
rm -rf paru-bin
paru -Syyu
```

# パッケージインストール

- 言語処理系

    - Rust

        ```sh
        export CARGO_HOME="${XDG_DATA_HOME}/cargo"
        export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
        rustup default stable
        ```

    - JavaScript/TypeScript

        ```sh
        test -n "${XDG_DATA_HOME}" && mkdir -p "${XDG_DATA_HOME}/npm/lib"
        ```
