# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

if [ "${USER}" = "root" ]; then
    echo \
'rootで実行しないでください
ユーザーを作成していない場合は
# homectl create --member-of=wheel,video --disk-size=100G --storage=luks [USERNAME]
でユーザーを作成してからログイン
'

    exit
fi

read -rp 'wireless? [y/N] ' is_wireless

case $is_wireless in
    [Yy]* )
        read -rp 'ssid: ' ssid
        read -rp 'passphrase: ' passphrase; echo
        ;;
    * )
        ;;
esac

read -rp 'nif name: ' nif_name
read -rp 'efi disk: ' efi_disk
read -rp 'efi part: ' efi_part
read -rp 'hostname: ' hostname
read -rp 'keymap: ' keymap
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
case $is_wireless in
    [Yy]* )
        wpa_passphrase "${ssid}" "${passphrase}" | sudo tee "/etc/wpa_supplicant/wpa_supplicant-${nif_name}.conf"
        sudo systemctl start "wpa_supplicant@${nif_name}.service"
        sudo systemctl enable "wpa_supplicant@${nif_name}.service"
        ;;
    * )
        ;;
esac

echo \
"[Match]
Name = ${nif_name}

[Network]
DHCP = yes
MulticastDNS = yes" | sudo tee "/etc/systemd/network/50-${nif_name}.network"

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
makepkg -si
cd ~
rm -rf paru-bin
paru -Syyu
```

# セキュアブート

## 必要パッケージのインストール

```sh
paru -S --noconfirm shim-signed sbsigntools mokutil efibootmgr
```

## ブートローダーの名前を変更

```sh
sudo cp /boot/EFI/BOOT/BOOTX64.EFI /boot/EFI/BOOT/grubx64.efi
```

## shimをコピー

```sh
sudo cp /usr/share/shim-signed/{shimx64.efi,mmx64.efi} /boot/EFI/BOOT/
```

## ブートエントリを変更

```sh
sudo efibootmgr -v

read -rp 'delete boot entry num: ' -a arr
for i in "${arr[@]}"; do
    sudo efibootmgr -B -b "${i}"
done

sudo efibootmgr -c -d "/dev/${efi_disk}" -p "${efi_part}" -l '\EFI\BOOT\shimx64.efi' -L 'Linux shim'

read -rp 'boot order num: ' -a arr
printf -v arr '%s,' "${arr[@]}"
sudo efibootmgr -o "${arr%,}"
```

## 秘密鍵と証明書の生成

- サブコマンドreqの引数-nodesがopenssl3では非推奨

```sh
sudo openssl req -x509 -newkey rsa:4096 -keyout '/root/mok.priv' -out '/root/mok.pem' -days 36500 -nodes -subj '/CN=Arch Linux Secure Boot/'
sudo openssl x509 -inform PEM -outform DER -in '/root/mok.pem' -out '/root/mok.der'
```

## カーネルとブートローダーに署名

```sh
sudo sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/vmlinuz-linux /boot/vmlinuz-linux
sudo sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/EFI/BOOT/grubx64.efi /boot/EFI/BOOT/grubx64.efi
```

## moklistに証明書を登録

```sh
sudo mokutil --import /root/mok.der
```

## pacman hookの設定

```sh
sudo mkdir /etc/pacman.d/hooks

echo \
'[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux

[Action]
Description = Signing Kernel for SecureBoot
When = PostTransaction
Exec = /usr/bin/sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/vmlinuz-linux /boot/vmlinuz-linux
Depends = sbsigntools' | sudo tee -a /etc/pacman.d/hooks/99-secureboot-kernel.hook

echo \
'[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = systemd

[Action]
Description = Signing BootLoader for SecureBoot
When = PostTransaction
Exec = /usr/bin/bash -c "/usr/bin/bootctl --no-variables --path=/boot update; /usr/bin/sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/EFI/BOOT/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI"
Depends = sbsigntools' | sudo tee -a /etc/pacman.d/hooks/99-secureboot-bootloader.hook
```

# パッケージインストール

- Radeonドライバインストール

    ```sh
    paru -S mesa libva-mesa-driver xf86-video-amdgpu vulkan-radeon rocm-opencl-sdk rocm-hip-sdk rocm-ml-sdk rocm-smi-lib
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
    paru -S --noconfirm xorg-server xorg-xinit xorg-xrandr i3-wm kitty xclip picom polybar rofi feh dunst libnotify light playerctl pipewire pipewire-pulse pipewire-jack wireplumber alsa-utils fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk
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
'#!/bin/nft

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;

        meta iif "lo" accept
        ct state { established, related } accept
        icmp type { echo-reply, echo-request } accept
        udp dport { mdns, llmnr } accept

        log prefix "[nft] "
    }
}' | sudo tee /etc/nftables.conf
```

```sh
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
read -rp 'mouse or touchpad [m/t]: ' ans
case $ans in
    [Mm]* )
        echo \
'Section "InputClass"
    Identifier "libinput mouse"
    Driver "libinput"
    MatchIsPointer "true"
    MatchDevicePath "/dev/input/event*"
    Option "AccelProfile" "flat"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-mouse.conf
        ;;
    [Tt]* )
        echo \
'Section "InputClass"
    Identifier "libinput touchpad"
    Driver "libinput"
    MatchIsTouchpad "true"
    MatchDevicePath "/dev/input/event*"
    Option "Tapping" "true"
    Option "NaturalScrolling" "true"
    Option "DisableWhileTyping" "false"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-touchpad.conf
        ;;
    * )
        ;;
esac
```

## reflectorの設定

```sh
echo \
'--save /etc/pacman.d/mirrorlist
--country Japan
--protocol http,https,ftp
--latest 5
--sort score' | sudo tee /etc/xdg/reflector/reflector.conf

sudo systemctl enable --now reflector.timer
```
