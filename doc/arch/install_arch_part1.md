# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

read -rp 'wireless? [y/N] ' is_wireless

case $is_wireless in
    [Yy]* )
        read -rp 'nif name: ' nif_name
        read -rp 'ssid: ' ssid
        read -rp 'passphrase: ' passphrase; echo
        ;;
    * )
        ;;
esac

read -rp 'esp: ' efi_part
read -rp 'root part: ' root_part
read -rp 'home part: ' home_part
```

# ライブ環境の設定

```sh
set +e

case $is_wireless in
    [Yy]* )
        pkill wpa_supplicant
        wpa_supplicant -B -i "${nif_name}" -c <(wpa_passphrase "${ssid}" "${passphrase}")
        ;;
    * )
        ;;
esac

while ! ping -c 1 -W 1 archlinux.jp; do
    echo 'waiting for connect archlinux.jp'
    sleep 5
done

set -e

timedatectl set-ntp true
reflector --country 'Japan' --sort rate --save /etc/pacman.d/mirrorlist
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
```

# パーティションのフォーマット

```sh
umount "/dev/${efi_part}" || true
umount "/dev/${home_part}" || true
umount "/dev/${root_part}" || true
mkfs.fat -F 32 "/dev/${efi_part}"
mkfs.ext4 -f "/dev/${root_part}"
mkfs.ext4 -f "/dev/${home_part}"
```

# ファイルシステムのマウント

```sh
mount "/dev/${root_part}" /mnt
mkdir -m 700 /mnt/boot
mount -o dmask=077,fmask=077 "/dev/${efi_part}" /mnt/boot
mkdir /mnt/home
mount "/dev/${home_part}" /mnt/home
```

# パッケージのインストール

```sh
pacstrap /mnt base linux linux-firmware amd-ucode base-devel git
case $is_wireless in
    [Yy]* )
        pacstrap /mnt wpa_supplicant
        ;;
    * )
        ;;
esac
```

# fstab生成

```sh
genfstab -U /mnt > /mnt/etc/fstab
```

# chroot

```sh
arch-chroot /mnt /bin/bash -euc "
echo 'change root passwd'
passwd

echo '%sudo ALL=(ALL:ALL) ALL' > /etc/sudoers.d/sudo
chmod 440 /etc/sudoers.d/sudo
visudo -csf /etc/sudoers.d/sudo

pwck -s
grpck -s

bootctl --path=/boot install

echo 'default arch
timeout 10
secure-boot-enroll manual
console-mode max' > /boot/loader/loader.conf

echo 'title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root=UUID=$(blkid -o value -s UUID /dev/"${root_part}") rw' > /boot/loader/entries/arch.conf
"
```

# 再起動するかどうかの確認

```sh
read -rp 'reboot [Y/n]: ' ans
case $ans in
    "" | [Yy]* )
        systemctl reboot
        ;;
    * )
        ;;
esac
```
