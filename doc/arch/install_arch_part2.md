# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

if [ "${USER}" = "root" ]; then
    echo \
'Do not run this script as root
# systemctl enable --now systemd-homed.service
# homectl create --member-of=wheel,video --disk-size=256G --storage=luks [USERNAME]
'

    exit
fi

read -rp 'nif name: ' nif_name
read -rp 'efi disk(ex: /dev/sda, /dev/nvme0n1): ' efi_disk
read -rp 'efi part(default: 1): ' efi_part
read -rp 'hostname: ' hostname
read -rp 'keymap(default: en): ' keymap

efi_part="${efi_part:-1}"
keymap="${keymap:-en}"
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
paru -S --noconfirm efibootmgr sbctl
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
    paru -S mesa libva-mesa-driver libva-utils xf86-video-amdgpu vulkan-radeon rocm-opencl-sdk rocm-hip-sdk rocm-ml-sdk rocm-smi-lib
    ```

- ミドルウェアのインストール

    ```sh
    paru -S --noconfirm openssh polkit gnome-keyring man-db man-pages arch-install-scripts reflector usbutils nftables
    ```

- CLIアプリのインストール

    ```sh
    paru -S --noconfirm bash-completion vim neovim zip unzip tree wget aria2 jq btop pipes.sh bat ripgrep fd git-delta neofetch
    ```

- デスクトップ環境のインストール

    ```sh
    paru -S --noconfirm xorg-server xorg-xinit xorg-xrandr i3-wm kitty xclip picom polybar rofi feh dunst libnotify playerctl pipewire pipewire-pulse pipewire-jack wireplumber alsa-utils fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk
    ```

- GUIアプリのインストール

    ```sh
    paru -S --noconfirm seahorse discord visual-studio-code-bin brave-bin gimp vlc thunderbird thunderbird-i18n-ja firefox firefox-i18n-ja gnome-screenshot peek libreoffice-fresh libreoffice-fresh-ja
    ```

- フォントのインストール

    ```sh
    paru -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-ubuntu-font-family ttf-ubuntu-mono-nerd
    ```

- 言語処理系

    - C/C++

        ```sh
        paru -S --noconfirm gdb clang lldb libc++ libc++abi cmake
        ```

    - Vulkan

        ```sh
        paru -S --noconfirm vulkan-devel
        ```

    - QMK firmware

        ```sh
        paru -S --noconfirm avr-gcc avr-libc arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-newlib dfu-programmer
        ```

    - Rust

        ```sh
        paru -S --noconfirm rustup rust-analyzer
        ```

    - Python

        ```sh
        paru -S --noconfirm python pyright rye python-black flake8
        ```

    - JavaScript/TypeScript

        ```sh
        paru -S --noconfirm nodejs npm deno typescript typescript-language-server
        ```

    - Lua

        ```sh
        paru -S --noconfirm lua-language-server stylua
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
