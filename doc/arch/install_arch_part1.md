# 設定項目の入力

```sh
#!/bin/bash -eu

function join_part () {
    if [[ "$(lsblk -dn -o TYPE ${1})" != 'disk' ]]; then
        false
        return
    fi

    if [[ $(basename ${1}) == sd* ]]; then
        echo "${1}${2}"
    elif [[ $(basename ${1}) == nvme* ]]; then
        echo "${1}p${2}"
    else
        false
        return
    fi
}

ip l
lsblk

while true; do
    read -rp 'install block device path(ex: /dev/sda, /dev/nvme0n1): ' install_block_device_path

    if [[ "$(lsblk -dn -o TYPE ${install_block_device_path})" = 'disk' ]]; then
        break
    else
        echo 'input block device path is not disk type'
    fi
done

read -rp 'EFI System Partition Size(default: 1G): ' esp_size
read -rp 'Root Logical Volume Percentage(default: 50): ' root_lv_percentage
read -rp 'Home Logical Volume Percentage(default: 50): ' home_lv_percentage
read -rp 'Volume Group Name(default: ArchLinux-VG): ' volume_group_name
read -rp 'Root Logical Volume Name(default: root-LV): ' root_lv_name
read -rp 'Home Logical Volume Name(default: home-LV): ' home_lv_name

esp_size="${esp_size:-1G}"
root_lv_percentage="${root_lv_percentage:-50}"
home_lv_percentage="${home_lv_percentage:-50}"
volume_group_name="${volume_group_name:-ArchLinux-VG}"
root_lv_name="${root_lv_name:-root-LV}"
home_lv_name="${home_lv_name:-home-LV}"

if [[ $((root_lv_percentage + home_lv_percentage)) > 100 ]]; then
    echo "root_lvとhome_lvの割合の合計が100を超えています"
    false
fi
```

# パーティショニング、LVMの設定

```sh
sgdisk --clear "${install_block_device_path}"
sgdisk --new "1::+${esp_size}" "${install_block_device_path}"
# ESP以外の範囲をすべてLVM用のパーティションにする
sgdisk --new '2::' "${install_block_device_path}"
sgdisk --typecode '1:EF00' "${install_block_device_path}"
sgdisk --typecode '2:8E00' "${install_block_device_path}"

pvcreate -y "$(join_part ${install_block_device_path} 2)"

vgcreate -y "${volume_group_name}" "$(join_part ${install_block_device_path} 2)"

lvcreate -l "${root_lv_percentage}%VG" -n root-LV "${volume_group_name}"
lvcreate -l "${home_lv_percentage}%VG" -n home-LV "${volume_group_name}"
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
umount -R "/mnt" || true
mkfs.fat -F 32 "$(join_part ${install_block_device_path} 1)"
mkfs.btrfs -f "/dev/${volume_group_name}/${root_lv_name}"
mkfs.btrfs -f "/dev/${volume_group_name}/${home_lv_name}"
```

# ファイルシステムのマウント

```sh
mount "/dev/${volume_group_name}/${root_lv_name}" /mnt
mkdir -m 700 /mnt/boot
mount -o dmask=077,fmask=077 "$(join_part ${install_block_device_path} 1)" /mnt/boot
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

sed -i '/^HOOKS/c HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block lvm2 filesystems fsck)' /etc/mkinitcpio.conf
mkinitcpio -p linux

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
options root=UUID=$(blkid -o value -s UUID "/dev/${volume_group_name}/${root_lv_name}") rw' > /boot/loader/entries/arch.conf
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
