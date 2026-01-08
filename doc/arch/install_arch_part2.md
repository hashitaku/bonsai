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

# その他設定

## Bluezの有効化

```sh
sudo systemctl enable --now bluetooth.service
```

## gnome-keyringの設定

```sh
tac /etc/pam.d/login | \
sed '0,/auth/ s/auth/auth       optional     pam_gnome_keyring.so\n&/' | \
sed '0,/session/ s/session/session    optional     pam_gnome_keyring.so    auto_start\n&/' | \
tac | \
uniq | \
sudo tee /etc/pam.d/login
```

## マウス、タッチパッド設定

```sh
echo \
'Section "InputClass"
    Identifier "libinput mouse"
    Driver "libinput"
    MatchIsPointer "true"
    MatchDevicePath "/dev/input/event*"
    Option "AccelProfile" "flat"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-mouse.conf
```

## その他

firefoxのハードウェアアクセラレーション対応状況を`about:support`で確認
ハードウェアアクセラレーションが有効になっていない場合は`about:config`で`media.ffmpeg.vaapi.enabled`をtrueにする
