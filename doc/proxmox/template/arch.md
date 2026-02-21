## ライブ環境の設定

```sh
echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
```

## パーティショニング

```sh
sgdisk --clear /dev/sda
sgdisk --new "1::+1G" /dev/sda
# ESP以外の範囲をすべてLVM用のパーティションにする
sgdisk --new '2::' /dev/sda
sgdisk --typecode '1:EF00' /dev/sda
sgdisk --typecode '2:8300' /dev/sda
```

## ファイルシステムの構築

```sh
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs -f /dev/sda2
```

## マウント

```sh
mount /dev/sda2 /mnt
mkdir -m 700 /mnt/boot
mount -o dmask=077,fmask=077 /dev/sda1 /mnt/boot
```

## fstab生成

```sh
genfstab -U /mnt > /mnt/etc/fstab
```

## パッケージインストール

```sh
declare -a pacstrap_packages=(
    'base'
    'base-devel'
    'linux'
    'linux-firmware'
    'btrfs-progs'
    'git'

    'polkit'
    'man-db'
    'man-pages'
    'nftables'

    'bash-completion'
    'neovim'

    'tailscale'
)

pacstrap /mnt "${pacstrap_packages[@]}"
```

## rootのパスワード設定

```sh
arch-chroot /mnt /bin/bash -euc "
echo 'change root passwd'
passwd
"
```

## ユーザーの設定

```sh
arch-chroot /mnt /bin/bash -euc "
useradd arch-user -m -G wheel,video
echo 'change arch-user passwd'
passwd arch-user

pwck -s
grpck -s

echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel
"
```

## pacmanの設定

```sh
arch-chroot /mnt /bin/bash -euc "
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sed -i '/Color/c Color' /etc/pacman.conf
"
```

## ブートマネージャーのインストール

```sh
arch-chroot /mnt /bin/bash -euc "
bootctl --path=/boot install

echo 'default arch
timeout 0
secure-boot-enroll manual
console-mode max' > /boot/loader/loader.conf

echo 'title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID=$(blkid -o value -s UUID /dev/sda2) console=ttyS0,115200 rw' > /boot/loader/entries/arch.conf
"
```

## ネットワーク設定

```sh
arch-chroot /mnt /bin/bash -euc "
echo \
'[Match]
Type = ether

[Network]
DHCP = true
MulticastDNS = true
LLMNR = true
IPv6PrivacyExtensions = true' | tee '/etc/systemd/network/50-wired.network'

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
"
```

## systemdのサービスの有効化


```sh
arch-chroot /mnt /bin/bash -euc "
systemctl enable tailscaled.service
systemctl enable serial-getty@ttyS0.service
"
```

`arch-chroot`では`/etc/resolv.conf`の設定がされてしまうため`chroot`を使用してシンボリックリンクを張る

```sh
chroot /mnt /bin/bash -euc '
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
'
```

## ホスト名・タイムゾーン・ロケールの設定

```sh
CONTAINER_NAME='INSTALL-CONTAINER'
systemd-run --quiet systemd-nspawn --directory=/mnt --boot --machine="${CONTAINER_NAME}"

sleep 5s

systemd-run --quiet --wait --pipe --uid=root --machine="${CONTAINER_NAME}" /bin/bash -euxc "
timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true

sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
locale-gen
localectl set-locale LANG=ja_JP.UTF-8
localectl set-keymap us

hostnamectl hostname arch-vm
"

machinectl stop "${CONTAINER_NAME}"
```
