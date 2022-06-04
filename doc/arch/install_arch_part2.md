# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

read -rp 'wireless? [Y/n] ' is_wireless

case $is_wireless in
    "" | [Y/y]* )
        read -rp 'ssid: ' ssid
        read -rp 'passphrase: ' passphrase; echo
        ;;
    * )
        ;;
esac

read -rp 'nif name: ' nif_name
read -rp 'esp: ' esp
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
    "" | [Y/y]* )
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

sudo systemctl start systemd-networkd.service
sudo systemctl enable systemd-networkd.service
sudo systemctl start systemd-resolved.service
sudo systemctl enable systemd-resolved.service

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

sudo efibootmgr -c -d "/dev/${esp:0:3}" -p "${esp:3}" -l '\EFI\BOOT\shimx64.efi' -L 'Linux shim'

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

- nvidiaドライバインストール

    ```sh
    paru -S --noconfirm nvidia
    ```
    
- ユーティリティのインストール

    ```sh
    paru -S --noconfirm bash-completion vim zip unzip tree wget polkit man-db man-pages-ja arch-install-scripts usbutils nftables
    ```

- デスクトップ環境のインストール

    ```sh
    paru -S --noconfirm xorg-server i3-gaps kitty xclip picom polybar rofi feh dunst libnotify light playerctl pipewire pipewire-pulse pipewire-jack wireplumber alsa-utils fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk
    ```

- フォントのインストール

    ```sh
    paru -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji
    ```

- その他インストール

    ```sh
    curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -
    paru -S --noconfirm gnome-keyring seahorse discord visual-studio-code-bin brave-bin firefox firefox-i18n-ja spotifyd spotify-tui spotify gnome-screenshot
    paru -S --noconfirm btop pipes.sh cava bat
    ```

- 言語処理系

    - C/C++

        ```sh
        paru -S --noconfirm clang libc++ libc++abi
        ```

    - Rust

        ```sh
        cd ~
        wget https://sh.rustup.rs -O rs.sh
        bash rs.sh -y --no-modify-path
        ~/.cargo/bin/rustup default nightly
        rm -r ~/rs.sh
        ```

    - Python

        ```sh
        paru -S --noconfirm python
        ```

    - JavaScript

        ```sh
        paru -S --noconfirm nodejs npm
        ```

# その他設定

## ファイアウォールの有効化

```sh
sudo systemctl enable nftables.service
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
    [M/m]* )
        echo \
'Section "InputClass"
    Identifier "libinput mouse"
    Driver "libinput"
    MatchIsPointer "true"
    MatchDevicePath "/dev/input/event*"
    Option "AccelProfile" "flat"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-mouse.conf
        ;;
    [T/t]* )
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

# dotfileのコピー

```sh
cd ~
git clone https://github.com/hashitaku/dotfile
cp -r ~/dotfile/home/{.bashrc,.config,.gitconfig,.inputrc,.profile,.vim,.xinitrc} ~/
rm -rf ~/dotfile
```
