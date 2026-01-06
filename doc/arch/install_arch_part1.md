# 初期設定

```sh
#!/bin/bash -eu

CONTAINER_NAME='INSTALL-CONTAINER'

function join_part() {
    if [[ "$(lsblk -dn -o TYPE "${1}")" != 'disk' ]]; then
        return 1
    fi

    if [[ $(basename "${1}") == sd* ]]; then
        echo "${1}${2}"
    elif [[ $(basename "${1}") == nvme* ]]; then
        echo "${1}p${2}"
    else
        return 1
    fi
}

function is_virt() {
    if [[ "$(systemd-detect-virt --vm)" == 'none' ]]; then
        return 1
    fi
}

function has_wlan() {
    ip link show dev wlan0 > /dev/null
}

export -f is_virt
export -f has_wlan
```

# 設定項目の入力

```sh
ip l
lsblk

while true; do
    read -rp 'install block device path(ex: /dev/sda, /dev/nvme0n1): ' install_block_device_path

    if [[ "$(lsblk -dn -o TYPE "${install_block_device_path}")" == 'disk' ]]; then
        break
    else
        echo 'input block device path is not disk type'
    fi
done

read -rp 'LUKS Mapping Name(default: cryptlvm): ' mapping_name
mapping_name="${mapping_name:-cryptlvm}"

read -rp 'EFI System Partition Size(default: 1G): ' esp_size
esp_size="${esp_size:-1G}"

read -rp 'Root Logical Volume Percentage(default: 50): ' root_lv_percentage
root_lv_percentage="${root_lv_percentage:-50}"

read -rp 'Home Logical Volume Percentage(default: 50): ' home_lv_percentage
home_lv_percentage="${home_lv_percentage:-50}"

read -rp 'Volume Group Name(default: ArchLinux-VG): ' volume_group_name
volume_group_name="${volume_group_name:-ArchLinux-VG}"

read -rp 'Root Logical Volume Name(default: root-LV): ' root_lv_name
root_lv_name="${root_lv_name:-root-LV}"

read -rp 'Home Logical Volume Name(default: home-LV): ' home_lv_name
home_lv_name="${home_lv_name:-home-LV}"

if [[ $((root_lv_percentage + home_lv_percentage)) -gt 100 ]]; then
    echo "Sum of root_lv and home_lv percentages exceeds 100"
    false
fi

read -rsp 'LUKS Password: ' luks_password1; echo;
read -rsp 'LUKS Password again: ' luks_password2; echo;
if [[ "${luks_password1}" != "${luks_password2}" ]]; then
    echo 'LUKS Password do not match'
    false
fi
luks_password="${luks_password1}"

read -rp 'hostname: ' hostname
if [[ "${hostname}" == "" ]]; then
    echo "hostname is empty"
    false
fi

read -rp 'keymap(default: us): ' keymap
keymap="${keymap:-us}"

read -rsp 'Root Password: ' root_password1; echo;
read -rsp 'Root Password again: ' root_password2; echo;
if [[ "${root_password1}" != "${root_password2}" ]]; then
    echo 'Root Password do not match'
    false
fi
root_password="${root_password1}"

read -rp 'User Name: ' user_name
if [[ -z "${user_name}" ]]; then
    echo "User is empty"
    false
fi

read -rsp 'User Password: ' user_password1; echo;
read -rsp 'User Password again: ' user_password2; echo;
if [[ "${user_password1}" != "${user_password2}" ]]; then
    echo 'User Password do not match'
    false
fi
user_password="${user_password1}"
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

echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
```

# ファイルシステム周りの設定

## パーティショニング

```sh
sgdisk --clear "${install_block_device_path}"
sgdisk --new "1::+${esp_size}" "${install_block_device_path}"
# ESP以外の範囲をすべてLVM用のパーティションにする
sgdisk --new '2::' "${install_block_device_path}"
sgdisk --typecode '1:EF00' "${install_block_device_path}"
sgdisk --typecode '2:8309' "${install_block_device_path}"
```

## LUKSの設定

```sh
echo "${luks_password}" | cryptsetup luksFormat --batch-mode "$(join_part "${install_block_device_path}" 2)"
echo "${luks_password}" | cryptsetup open "$(join_part "${install_block_device_path}" 2)" "${mapping_name}"
```

## LVMの設定

```sh
pvcreate -y "/dev/mapper/${mapping_name}"

vgcreate -y "${volume_group_name}" "/dev/mapper/${mapping_name}"

lvcreate -y -l "${root_lv_percentage}%VG" -n "${root_lv_name}" "${volume_group_name}"
lvcreate -y -l "${home_lv_percentage}%VG" -n "${home_lv_name}" "${volume_group_name}"
```

## パーティションのフォーマット

```sh
umount -R "/mnt" || true
mkfs.fat -F 32 "$(join_part "${install_block_device_path}" 1)"
mkfs.btrfs -f "/dev/${volume_group_name}/${root_lv_name}"
mkfs.btrfs -f "/dev/${volume_group_name}/${home_lv_name}"
```

## ファイルシステムのマウント

```sh
mount "/dev/${volume_group_name}/${root_lv_name}" /mnt
mkdir -m 700 /mnt/boot
mount -o dmask=077,fmask=077 "$(join_part "${install_block_device_path}" 1)" /mnt/boot
mkdir /mnt/home
mount "/dev/${volume_group_name}/${home_lv_name}" /mnt/home
```

# パッケージのインストール

仮想環境の時はセキュアブートの設定は行わないため`sbctl`は不要

```sh
declare -a pacstrap_packages=(
    'base'
    'base-devel'
    'linux'
    'linux-firmware'
    'cryptsetup'
    'tpm2-tss'
    'libfido2'
    'lvm2'
    'btrfs-progs'
    'efibootmgr'
    'git'
)

if ! is_virt; then
    pacstrap_packages+=('amd-ucode' 'sbctl')
fi

if has_wlan; then
    pacstrap_packages+=('iwd')
fi

pacstrap /mnt "${pacstrap_packages[@]}"
```

# fstab生成

```sh
genfstab -U /mnt > /mnt/etc/fstab
```

# arch-chroot

## rootパスワードの設定

```sh
arch-chroot /mnt /bin/bash -euc "
echo 'change root passwd'
echo "root:${root_password}" | chpasswd
"
```

## ユーザーの追加

```sh
arch-chroot /mnt /bin/bash -euc "
useradd ${user_name} -m -G wheel,video
echo 'change ${user_name} passwd'
echo "${user_name}:${user_password}" | chpasswd

pwck -s
grpck -s
"
```

## sudoersの設定

```sh
arch-chroot /mnt /bin/bash -euc "
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel
"
```

## ブートマネージャーのインストール

```sh
arch-chroot /mnt /bin/bash -euc "
bootctl --path=/boot install

echo 'default arch
timeout 10
secure-boot-enroll manual
console-mode max' > /boot/loader/loader.conf

echo 'title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options rd.luks.name=$(blkid -o value -s UUID $(join_part "${install_block_device_path}" 2))=${mapping_name} root=UUID=$(blkid -o value -s UUID /dev/"${volume_group_name}"/"${root_lv_name}") rw' > /boot/loader/entries/arch.conf
"
```

## セキュアブート

仮想環境ではセキュアブートの設定を行わない

```sh
arch-chroot /mnt /bin/bash -euc "
if ! is_virt; then
    sbctl create-keys
    sbctl enroll-keys -m
    sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
    sbctl sign -s /boot/vmlinuz-linux
fi
"
```

## mkinitcpio.confの設定

initramfsで実行するフックの設定

項目と順序が大切であるため以下用参照

https://wiki.archlinux.jp/index.php/Mkinitcpio#%E9%80%9A%E5%B8%B8%E3%81%AE%E3%83%95%E3%83%83%E3%82%AF

```sh
arch-chroot /mnt /bin/bash -euc "
touch /etc/vconsole.conf
sed -i '/^HOOKS/c HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)' /etc/mkinitcpio.conf
mkinitcpio -p linux
"
```

## ネットワークの設定

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
"
```

```sh
if has_wlan; then
    arch-chroot /mnt /bin/bash -euc "
echo \
'[Match]
Type = wlan

[Network]
DHCP = true
MulticastDNS = true
LLMNR = true
IPv6PrivacyExtensions = true' | tee '/etc/systemd/network/50-wireless.network'
"
fi
```

```sh
arch-chroot /mnt /bin/bash -euc '
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

if has_wlan; then
    systemctl enable iwd.service
fi
'
```

`arch-chroot`では`/etc/resolv.conf`の設定がされてしまうため`chroot`を使用してシンボリックリンクを張る

```sh
chroot /mnt /bin/bash -euc "
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
"
```

## タイムゾーン・ロケールの設定

```sh
systemd-run --quiet systemd-nspawn --directory=/mnt --boot --machine="${CONTAINER_NAME}"

systemd-run --quiet --pipe --uid=root --machine="${CONTAINER_NAME}" /bin/bash -euc "
timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true

sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
locale-gen
localectl set-locale LANG=ja_JP.UTF-8
localectl set-keymap "${keymap}"
"

machinectl stop "${CONTAINER_NAME}"
```

# ブートエントリを変更

```sh
efibootmgr -v

read -rp 'delete boot entry num: ' -a arr
for i in "${arr[@]}"; do
    efibootmgr -B -b "${i}"
done

efibootmgr -c -d "${install_block_device_path}" -p '1' -l '\EFI\BOOT\BOOTX64.EFI' -L 'Systemd Boot'

read -rp 'boot order num: ' -a arr
printf -v arr '%s,' "${arr[@]}"
efibootmgr -o "${arr%,}"
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
