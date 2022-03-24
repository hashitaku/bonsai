#!/bin/bash -eu

ip l
lsblk

read -rp 'nif: ' nif
read -rp 'ssid: ' ssid
read -rsp 'passphrase: ' passphrase; echo
read -rp 'esp: ' esp
read -rp 'hostname: ' hostname
read -rp 'keymap: ' keymap

# タイムゾーンの設定
sudo timedatectl set-timezone Asia/Tokyo
sudo timedatectl set-ntp true

# ロケール設定
sudo sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=ja_JP.UTF-8
echo -e 'FONT=sun12x22' | sudo tee /etc/vconsole.conf
sudo localectl set-keymap "${keymap}"

# ホストネーム設定
sudo hostnamectl hostname "${hostname}"

# ネットワーク設定
wpa_passphrase "${ssid}" "${passphrase}" | sudo tee "/etc/wpa_supplicant/wpa_supplicant-${nif}.conf"
echo "[Match]
Name = ${nif}

[Network]
DHCP = yes" | sudo tee "/etc/systemd/network/50-wireless.network"
sudo systemctl start "wpa_supplicant@${nif}.service"
sudo systemctl enable "wpa_supplicant@${nif}.service"
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

# pacman設定
sudo sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sudo sed -i '/Color/c Color' /etc/pacman.conf

# AURヘルパーのインストール
cd ~
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
rm -rf paru-bin
paru -Syyu

# セキュアブートに必要なパッケージのインストール
paru -S shim-signed sbsigntools mokutil efibootmgr

# ブートローダーの名前を変更
sudo mv /boot/EFI/BOOT/BOOTX64.EFI /boot/EFI/BOOT/grubx64.efi

# shimをコピー
sudo cp /usr/share/shim-signed/{shimx64.efi,mmx64.efi} /boot/EFI/BOOT/

# ブートエントリを変更
sudo efibootmgr -v

read -rp 'delete boot entry num: ' -a arr
for i in "${arr[@]}"; do
    sudo efibootmgr -B -b "${i}"
done

sudo efibootmgr -c -d "/dev/${esp:0:3}" -p "${esp:3}" -l '\EFI\BOOT\shimx64.efi' -L 'Linux shim'

read -rp 'boot order num: ' -a arr
sudo efibootmgr -

# 秘密鍵と証明書の生成
# サブコマンドreqの引数-nodesがopenssl3では非推奨
sudo openssl req -x509 -newkey rsa:4096 -keyout '/root/mok.priv' -out '/root/mok.pem' -days 36500 -nodes -subj '/CN=Arch Linux Secure Boot/'
sudo openssl x509 -inform PEM -outform DER -in '/root/mok.pem' -out '/root/mok.der'

# カーネルとブートローダーに署名
sudo sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/vmlinuz-linux /boot/vmlinuz-linux
sudo sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/EFI/BOOT/grubx64.efi /boot/EFI/BOOT/grubx64.efi

# moklistに証明書を登録
sudo mokutil --import /root/mok.der

# pacman hookの設定
mkdir /etc/pacman.d/hooks

echo '[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux

[Action]
Description = Signing Kernel for SecureBoot
When = PostTransaction
Exec = /usr/bin/sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/vmlinuz-linux /boot/vmlinuz-linux
Depends = sbsigntools' | sudo tee -a /etc/pacman.d/hooks/99-secureboot-kernel.hook

echo '[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = systemd

[Action]
Description = Signing BootLoader for SecureBoot
When = PostTransaction
Exec = /usr/bin/bash -c "/usr/bin/bootctl --no-variables --path=/boot update; /usr/bin/sbsign --key /root/mok.priv --cert /root/mok.pem --output /boot/EFI/BOOT/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI"
Depends = sbsigntools' | sudo tee -a /etc/pacman.d/hooks/99-secureboot-bootloader.hook

# nvidiaドライバインストール
paru -S nvidia

# ユーティリティのインストール
paru -S bash-completion vim zip unzip tree btop wget

# デスクトップ環境インストール
paru -S xorg-server i3-gaps kitty xclip lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan picom rofi feh dunst light pulseaudio alsa-utils fcitx5-mozc fcitx5-configtool noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji

# lightdmの有効化
sudo systemctl enable lightdm.service

# dotfileのコピー
cd ~
git clone https://github.com/hashitaku/dotfile
cp -r ~/dotfile/home/{.config,.bashrc,.profile,.xprofile,.inputrc,.gitconfig} ~/
rm -rf ~/dotfile
