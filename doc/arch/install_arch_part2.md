# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

read -rp 'nif name: ' nif_name
read -rp 'efi disk(ex: /dev/sda, /dev/nvme0n1): ' efi_disk
read -rp 'efi part(default: 1): ' efi_part
read -rp 'hostname: ' hostname
read -rp 'keymap(default: us): ' keymap

efi_part="${efi_part:-1}"
keymap="${keymap:-us}"
```

# 初期設定

## タイムゾーンの設定

```sh
sudo timedatectl set-timezone Asia/Tokyo
sudo timedatectl set-ntp true
```

## ロケール設定

```sh
sudo sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=ja_JP.UTF-8
echo -e 'FONT=sun12x22' | sudo tee /etc/vconsole.conf
sudo localectl set-keymap "${keymap}"
```

## ホストネーム設定

```sh
sudo hostnamectl hostname "${hostname}"
```

## ネットワーク設定

```sh
echo \
"[Match]
Name = ${nif_name}

[Network]
DHCP = true
MulticastDNS = true
LLMNR = true
IPv6PrivacyExtensions = true" | sudo tee "/etc/systemd/network/50-${nif_name}.network"

sudo systemctl enable --now systemd-networkd.service
sudo systemctl enable --now systemd-resolved.service

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

set +e
while ! ping -c 1 -W 1 archlinux.jp; do
    echo 'waiting for connect archlinux.jp'
    sleep 5
done
set -e
```

## pacman設定

```sh
sudo sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sudo sed -i '/Color/c Color' /etc/pacman.conf
```

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

# セキュアブート

## 必要パッケージのインストール

```sh
paru -S --noconfirm --asexplicit efibootmgr sbctl
```

## 鍵の生成

```sh
sudo sbctl create-keys
```

## 鍵の登録

```sh
sudo sbctl enroll-keys -m
```

## ブートローダー、カーネルの署名

```sh
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign -s /boot/vmlinuz-linux
```

## ブートエントリを変更

```sh
sudo efibootmgr -v

read -rp 'delete boot entry num: ' -a arr
for i in "${arr[@]}"; do
    sudo efibootmgr -B -b "${i}"
done

sudo efibootmgr -c -d "${efi_disk}" -p "${efi_part}" -l '\EFI\BOOT\BOOTX64.EFI' -L 'Systemd Boot'

read -rp 'boot order num: ' -a arr
printf -v arr '%s,' "${arr[@]}"
sudo efibootmgr -o "${arr%,}"
```

# パッケージインストール

- Radeonドライバインストール

    ```sh
    paru -S --noconfirm --asexplicit mesa libva-utils xf86-video-amdgpu vulkan-radeon rocm-opencl-sdk rocm-hip-sdk rocm-ml-sdk rocm-smi-lib
    ```

- ミドルウェアのインストール

    ```sh
    paru -S --noconfirm --asexplicit openssh polkit gnome-keyring man-db man-pages arch-install-scripts usbutils nftables bluez bluez-utils libappimage
    ```

- CLIアプリのインストール

    ```sh
    paru -S --noconfirm --asexplicit bash-completion neovim oh-my-posh-bin zip unzip tree wget aria2 jq btop pipes.sh bat ripgrep fd erdtree git-delta neofetch glow
    ```

- デスクトップ環境のインストール

    ```sh
    paru -S --noconfirm --asexplicit xorg-server xorg-xinit xorg-xrandr i3-wm wezterm xclip picom polybar rofi feh dunst libnotify playerctl pipewire pipewire-pulse pipewire-jack wireplumber alsa-utils fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk
    ```

- GUIアプリのインストール

    ```sh
    paru -S --noconfirm --asexplicit seahorse discord visual-studio-code-bin brave-bin gimp vlc thunderbird thunderbird-i18n-ja firefox firefox-i18n-ja gnome-screenshot peek libreoffice-fresh libreoffice-fresh-ja
    ```

- フォントのインストール

    ```sh
    paru -S --noconfirm --asexplicit noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-ubuntu-mono-nerd ttf-inconsolata-nerd
    ```

- 言語処理系

    - C/C++

        ```sh
        paru -S --noconfirm --asexplicit gdb clang lldb libc++ libc++abi cmake meson mesonlsp ninja
        ```

    - Vulkan

        ```sh
        paru -S --noconfirm --asexplicit vulkan-devel
        ```

    - QMK firmware

        ```sh
        paru -S --noconfirm --asexplicit avr-gcc avr-libc arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-newlib dfu-programmer
        ```

    - Rust

        ```sh
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
        ```

    - Python

        ```sh
        paru -S --noconfirm --asexplicit python ruff pyright uv
        ```

    - JavaScript/TypeScript

        ```sh
        paru -S --noconfirm --asexplicit nodejs fnm-bin npm deno typescript typescript-language-server
        test -z "${XDG_DATA_HOME}" && mkdir -p "${XDG_DATA_HOME}/npm/lib"
        ```

    - Lua

        ```sh
        paru -S --noconfirm --asexplicit lua-language-server stylua
        ```

    - Typst

        ```sh
        paru -S --noconfirm --asexplicit typst tinymist
        ```

# その他設定

## カーネルモジュールの自動ロード

```sh
echo 'ntfs3' | sudo tee /etc/modules-load.d/ntfs3.conf
```

## ファイアウォールの有効化

```sh
echo \
'# add table inet filter
# create chain inet filter input { type filter hook input priority 0; policy drop; }
# add rule inet filter input meta iifname "lo" accept
# add rule inet filter input ct state { established, related } accept
# add rule inet filter input icmp type { echo-reply, echo-request } accept
# add rule inet filter input icmpv6 type { echo-request, echo-reply, mld-listener-query, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert  } accept
# add rule inet filetr input udp dport { mdns, llmnr } accept
# add rule inet filter input log prefix "[nft] "

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;

        meta iif "lo" accept
        ct state { established, related } accept

        icmp type { echo-reply, echo-request } accept
        icmpv6 type { echo-request, echo-reply, mld-listener-query, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept

        udp dport { mdns, llmnr } accept

        log prefix "[nft] "
    }
}' | sudo tee /etc/nftables.conf

sudo systemctl enable --now nftables.service
```

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
