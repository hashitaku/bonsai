# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

read -rp 'wireless? [Y/n] ' is_wireless

case $is_wireless in
    "" | [Y/y]* )
        read -rp 'nif name: ' nif_name
        read -rp 'ssid: ' ssid
        read -rp 'passphrase: ' passphrase; echo
        ;;
    * )
        ;;
esac

read -rp 'esp: ' esp
read -rp 'root part: ' root
read -rp 'username: ' user
```

# ライブ環境の設定

```sh
set +e

case $is_wireless in
    "" | [Y/y]* )
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
reflector --country 'Japan' --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
```

# パーティションのフォーマット

```sh
umount "/dev/${esp}" || true
umount "/dev/${root}" || true
mkfs.fat -F 32 "/dev/${esp}"
mkfs.ext4 "/dev/${root}"
```

# ファイルシステムのマウント

```sh
mount "/dev/${root}" /mnt
mkdir /mnt/boot
mount "/dev/${esp}" /mnt/boot
```

# パッケージのインストール

```sh
pacstrap /mnt base linux linux-firmware intel-ucode base-devel git
case $is_wireless in
    "" | [Y/y]* )
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

echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel

useradd ${user} -m -G wheel,video
echo 'change ${user} passwd'
passwd ${user}

pwck -s
grpck -s

bootctl --path=/boot install

echo 'default arch
timeout 10
console-mode max' > /boot/loader/loader.conf

echo 'title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=UUID=$(blkid -o value -s UUID /dev/"${root}") rw' > /boot/loader/entries/arch.conf
"
```

# 再起動するかどうかの確認

```sh
read -rp 'reboot [Y/n]: ' ans
case $ans in
    "" | [Y/y]* )
        systemctl reboot
        ;;
    * )
        ;;
esac
```
