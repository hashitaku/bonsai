# 設定項目の入力

```sh
#!/bin/bash -eu

ip l
lsblk

while true; do
    read -rp 'install block device path(ex: /dev/sda, /dev/nvme0n1): ' install_block_device_path

    if [[ "$(lsblk -dn -o TYPE ${install_block_device_path})" == 'disk' ]]; then
        break
    else
        echo 'input block device path is not disk type'
    fi
done

read -rp 'EFI System Partition Size(default: 1G): ' esp_size
read -rp 'Root Partition Size(default: 256G): ' root_size
read -rp 'Home Partition Size(default: 256G): ' home_size
read -rp 'Volume Group Name(default: ArchLinux-VG): ' volume_group_name
read -rp 'Root Logical Volume Name(default: root-LV): ' root_lv_name
read -rp 'Home Logical Volume Name(default: home-LV): ' home_lv_name

esp_size="${esp_size:-1G}"
root_size="${root_size:-256G}"
home_size="${home_size:-256G}"
volume_group_name="${volume_group_name:-ArchLinux-VG}"
root_lv_name="${root_lv_name:-root-LV}"
home_lv_name="${home_lv_name:-home-LV}"
```

# パーティショニング、LVMの設定

```sh
sgdisk --clear "${install_block_device_path}"
sgdisk --new "1::+${esp_size}" "${install_block_device_path}"
# ESP以外の範囲をすべてLVM用のパーティションにする
sgdisk --new '2::' "${install_block_device_path}"
sgdisk --typecode '1:EF00' "${install_block_device_path}p1"
sgdisk --typecode '2:8E00' "${install_block_device_path}p2"

# パーティション番号とディスクパスからファイルパスを得る方法が不明なのでnvme向けにのみ対応
pvcreate "${install_block_device_path}p2"

vgcreate "${volume_group_name}" "${install_block_device_path}p2"

lvcreate -L "${root_size}" -n root-LV "${volume_group_name}"
lvcreate -L "${home_size}" -n home-LV "${volume_group_name}"
```

# ライブ環境の設定

```sh
set +e

while ! ping -c 1 -W 1 archlinux.jp; do
    echo 'waiting for connect archlinux.jp'
    sleep 5
done

set -e

timedatectl set-ntp true
echo 'Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
```

# パーティションのフォーマット

```sh
# パーティション番号とディスクパスからファイルパスを得る方法が不明なのでnvme向けにのみ対応
umount -R "/mnt" || true
mkfs.fat -F 32 "${install_block_device_path}p1"
mkfs.btrfs -f "/dev/${volume_group_name}/${root_lv_name}"
mkfs.btrfs -f "/dev/${volume_group_name}/${home_lv_name}"
```

# ファイルシステムのマウント

```sh
mount "/dev/${volume_group_name}/${root_lv_name}" /mnt
mkdir -m 700 /mnt/boot
mount -o dmask=077,fmask=077 "${install_block_device_path}p1" /mnt/boot
mkdir /mnt/home
mount "/dev/${volume_group_name}/${home_lv_name}" /mnt/home
```

# パッケージのインストール

```sh
pacstrap /mnt base base-devel linux linux-firmware amd-ucode lvm2 btrfs-progs git
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
chmod 440 /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel

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
options root=UUID=$(blkid -o value -s UUID /dev/"${install_block_device_path}p1") rw' > /boot/loader/entries/arch.conf
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
