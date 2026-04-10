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
    if ip link show dev wlan0 &> /dev/null; then
        return 0
    fi

    return 1
}

function has_bt() {
    if [[ -e /sys/class/bluetooth/* ]]; then
        return 0
    fi

    return 1
}

export -f is_virt
export -f has_wlan
export -f has_bt
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

read -rp 'LUKS Mapping Name(default: cryptroot): ' mapping_name
mapping_name="${mapping_name:-cryptroot}"

read -rp 'EFI System Partition Size(default: 1G): ' esp_size
esp_size="${esp_size:-1G}"

read -rsp 'LUKS Password: ' luks_password1; echo;
read -rsp 'LUKS Password again: ' luks_password2; echo;
if [[ "${luks_password1}" != "${luks_password2}" ]]; then
    echo 'LUKS Password do not match'
    false
fi
luks_password="${luks_password1}"

read -rp 'hostname: ' hostname
if [[ "${hostname}" == "" ]]; then
    echo 'hostname is empty'
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
    echo 'User is empty'
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
systemctl disable --now reflector

echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.leaseweb.net/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
```

# ファイルシステムの設定

## パーティショニング

```sh
sgdisk --clear "${install_block_device_path}"
sgdisk --new "1::+${esp_size}" "${install_block_device_path}"
sgdisk --new '2::' "${install_block_device_path}"
sgdisk --typecode '1:EF00' "${install_block_device_path}"
sgdisk --typecode '2:8309' "${install_block_device_path}"
```

## LUKSの設定

```sh
echo "${luks_password}" | cryptsetup luksFormat --batch-mode "$(join_part "${install_block_device_path}" 2)"
echo "${luks_password}" | cryptsetup open "$(join_part "${install_block_device_path}" 2)" "${mapping_name}"
```

## パーティションのフォーマット

```sh
umount -R '/mnt' || true
udevadm settle
mkfs.fat -F 32 "$(join_part "${install_block_device_path}" 1)"
mkfs.btrfs -f "/dev/mapper/${mapping_name}"
```

## btrfsサブボリュームの作成

```sh
mount "/dev/mapper/${mapping_name}" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
```

## ファイルシステムのマウント

```sh
mount -o subvol=@ "/dev/mapper/${mapping_name}" /mnt
mkdir /mnt/home
mkdir -m 700 /mnt/boot
mount -o subvol=@home "/dev/mapper/${mapping_name}" /mnt/home
mount -o dmask=077,fmask=077 "$(join_part "${install_block_device_path}" 1)" /mnt/boot
```

# パッケージのインストール

```sh
declare -a pacstrap_packages=(
    # base
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

    # drivers
    'mesa'

    # middleware
    'openssh'
    'polkit'
    'gnome-keyring'
    'man-db'
    'man-pages'
    'arch-install-scripts'
    'usbutils'
    'tailscale'
    'nftables'
    'libappimage'

    # CLI Application
    'bash-completion'
    'neovim'
    'zip'
    'unzip'
    'tree'
    'wget'
    'aria2'
    'jq'
    'btop'
    'bat'
    'ripgrep'
    'fd'
    'fzf'
    'erdtree'
    'git-delta'
    'fastfetch'
    'glow'
    'lazygit'
    'github-cli'

    # Desktop Environment
    'xorg-server'
    'xorg-xinit'
    'xorg-xrandr'
    'i3-wm'
    'xclip'
    'picom'
    'polybar'
    'rofi'
    'feh'
    'dunst'
    'libnotify'
    'playerctl'
    'pipewire'
    'pipewire-pulse'
    'pipewire-jack'
    'wireplumber'
    'alsa-utils'
    'fcitx5-mozc'
    'fcitx5-configtool'
    'fcitx5-qt'
    'fcitx5-gtk'

    # GUI Application
    'wezterm'
    'seahorse'
    'discord'
    'gimp'
    'vlc'
    'thunderbird'
    'thunderbird-i18n-ja'
    'firefox'
    'firefox-i18n-ja'
    'gnome-screenshot'
    'peek'
    'libreoffice-fresh'
    'libreoffice-fresh-ja'

    # fonts
    'noto-fonts'
    'noto-fonts-cjk'
    'noto-fonts-extra'
    'noto-fonts-emoji'
    'ttf-ubuntu-mono-nerd'
    'ttf-inconsolata-nerd'

    # podman
    'podman'

    # LLM
    'codex'

    # C/C++
    'gdb'
    'clang'
    'lldb'
    'libc++'
    'libc++abi'
    'cmake'
    'meson'
    'ninja'

    # vulkan
    'vulkan-devel'

    # QMK firmware
    'avr-gcc'
    'avr-libc'
    'arm-none-eabi-binutils'
    'arm-none-eabi-gcc'
    'arm-none-eabi-newlib'
    'dfu-programmer'

    # Rust
    'rustup'

    # Python
    'python'
    'ruff'
    'pyright'
    'uv'

    # JavaScript/TypeScript
    'nodejs'
    'fnm'
    'npm'
    'deno'
    'bun'
    'typescript'
    'typescript-language-server'

    # Lua
    'lua-language-server'
    'stylua'

    # Typst
    'typst'
    'tinymist'
)

# 仮想環境の時はセキュアブートの設定は行わないため`sbctl`は不要
if ! is_virt; then
    pacstrap_packages+=(
        'amd-ucode'

        'libva'
        'libva-utils'
        'xf86-video-amdgpu'
        'vulkan-radeon'
        'rocm-opencl-sdk'
        'rocm-hip-sdk'
        'rocm-ml-sdk'
        'rocm-smi-lib'

        'sbctl'
    )
fi

if has_wlan; then
    pacstrap_packages+=('iwd')
fi

if has_bt; then
    pacstrap_packages+=('bluez' 'bluez-utils')
fi

pacstrap /mnt "${pacstrap_packages[@]}"
```

## インストール用コンテナの立ち上げ

`/etc/resolv.conf`はセットアップ完了後はシンボリックリンクであってほしいが、セットアップ中のコンテナ内では`systemd-nspawn`の`bind-stub`で設定されている必要がある

そのため、コンテナ実行前にシンボリックリンクを張り、コンテナはホストのスタブを使用する

`arch-chroot`では`/etc/resolv.conf`の設定がされてしまうため`chroot`を使用してシンボリックリンクを張る

```sh
chroot /mnt /bin/bash -euc '
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
'

systemd-run --quiet systemd-nspawn --directory=/mnt --resolv-conf=bind-stub --boot --machine="${CONTAINER_NAME}"

sleep 5s

systemd-run --quiet --wait --pipe --uid=root --machine="${CONTAINER_NAME}" /bin/bash -euc "
echo '${user_name} ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99-${user_name}
chmod 440 /etc/sudoers.d/99-${user_name}
visudo -csf /etc/sudoers.d/99-${user_name}
"
```

## fstab生成

```sh
genfstab /mnt > /mnt/etc/fstab
```

# arch-chroot

## rootパスワードの設定

```sh
arch-chroot /mnt /bin/bash -euc "
echo 'change root passwd'
echo 'root:${root_password}' | chpasswd
"
```

## ユーザーの追加

```sh
arch-chroot /mnt /bin/bash -euc "
useradd ${user_name} -m -G wheel,video
echo 'change ${user_name} passwd'
echo '${user_name}:${user_password}' | chpasswd

pwck -s
grpck -s
"
```

## sudoersの設定

```sh
arch-chroot /mnt /bin/bash -euc "
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00-wheel
chmod 440 /etc/sudoers.d/00-wheel
visudo -csf /etc/sudoers.d/00-wheel
"
```

## pacman設定

```sh
arch-chroot /mnt /bin/bash -euc "
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sed -i '/Color/c Color' /etc/pacman.conf
sed -i '/VerbosePkgLists/c VerbosePkgLists' /etc/pacman.conf
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
options rd.luks.name=$(blkid -o value -s UUID $(join_part ${install_block_device_path} 2))=${mapping_name} root=UUID=$(blkid -o value -s UUID /dev/mapper/${mapping_name}) rootflags=subvol=@ rw' > /boot/loader/entries/arch.conf
"
```

## mkinitcpio.confの設定

initramfsで実行するフックの設定

項目と順序が大切であるため以下用参照

https://wiki.archlinux.jp/index.php/Mkinitcpio#%E9%80%9A%E5%B8%B8%E3%81%AE%E3%83%95%E3%83%83%E3%82%AF

```sh
arch-chroot /mnt /bin/bash -euc "
touch /etc/vconsole.conf
sed -i '/^HOOKS/c HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)' /etc/mkinitcpio.conf
mkinitcpio -p linux
"
```

## セキュアブート

仮想環境ではセキュアブートの設定を行わない

```sh
if ! is_virt; then
    arch-chroot /mnt /bin/bash -euc "
sbctl create-keys
sbctl enroll-keys -m
sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
sbctl sign -s /boot/vmlinuz-linux
"
fi
```

## カーネルモジュールの自動ロード

```sh
arch-chroot /mnt /bin/bash -euc "
echo 'ntfs3' | tee /etc/modules-load.d/ntfs3.conf
"
```

## pamの設定

`/bin/login`を使用してログインする際の`gnome-keyring`解除設定

```sh
arch-chroot /mnt /bin/bash -euc "
tac /etc/pam.d/login | \
sed '0,/auth/ s/auth/auth       optional     pam_gnome_keyring.so\n&/' | \
sed '0,/session/ s/session/session    optional     pam_gnome_keyring.so    auto_start\n&/' | \
tac | \
uniq | \
tee login.tmp

mv login.tmp /etc/pam.d/login
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
systemctl enable tailscaled.service
'
```

ホストがWlanを持ってい場合のみ`iwd`がインストールされているため有効化

```sh
if has_wlan; then
    arch-chroot /mnt /bin/bash -euc 'systemctl enable iwd.service'
fi
```

ホストがbluetoothを持っている場合のみ`bluez`がインストールされているため有効化

```sh
if has_bt; then
    arch-chroot /mnt /bin/bash -euc 'systemctl enable bluetooth.service'
fi
```

## ファイアウォールの有効化

```sh
arch-chroot /mnt /bin/bash -euc "
echo \
'# add table inet filter
# create chain inet filter input { type filter hook input priority 0; policy drop; }
# add rule inet filter input meta iifname \"lo\" accept
# add rule inet filter input ct state { established, related } accept
# add rule inet filter input icmp type { echo-reply, echo-request } accept
# add rule inet filter input icmpv6 type { echo-request, echo-reply, mld-listener-query, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert  } accept
# add rule inet filetr input udp dport { mdns, llmnr } accept
# add rule inet filter input log prefix \"[nft] \"

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;

        meta iif \"lo\" accept
        ct state { established, related } accept

        icmp type { echo-reply, echo-request } accept
        icmpv6 type { echo-request, echo-reply, mld-listener-query, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept

        udp dport { mdns, llmnr } accept

        log prefix \"[nft] \"
    }
}' | tee /etc/nftables.conf

systemctl enable nftables.service
"
```

## ホスト名・タイムゾーン・ロケールの設定

```sh
systemd-run --quiet --wait --pipe --uid=root --machine="${CONTAINER_NAME}" /bin/bash -euc "
timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true

sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
locale-gen
localectl set-locale LANG=ja_JP.UTF-8
localectl set-keymap ${keymap}

hostnamectl hostname ${hostname}
"
```

## マウス、タッチパッド設定

```sh
systemd-run --quiet --wait --pipe --uid=root --machine="${CONTAINER_NAME}" /bin/bash -euc '
echo \
"Section "InputClass"
    Identifier "libinput mouse"
    Driver "libinput"
    MatchIsPointer "true"
    MatchDevicePath "/dev/input/event*"
    Option "AccelProfile" "flat"
EndSection" | tee /etc/X11/xorg.conf.d/20-mouse.conf

echo \
"Section "InputClass"
    Identifier "libinput touchpad"
    Driver "libinput"
    MatchIsTouchpad "true"
    MatchDevicePath "/dev/input/event*"
    Option "Tapping" "true"
    Option "NaturalScrolling" "true"
    Option "DisableWhileTyping" "false"
EndSection" | tee /etc/X11/xorg.conf.d/20-touchpad.conf
'
```

## 言語処理系のインストール

- Rust

    `paru`のインストールのために先にツールチェーンがインストールされている必要がある

    ```sh
    systemd-run --quiet --wait --pipe --uid="${user_name}" --machine="${CONTAINER_NAME}" /bin/bash -euc '
    export CARGO_HOME="${HOME}/.local/share/cargo"
    export RUSTUP_HOME="${HOME}/.local/share/rustup"
    rustup default stable
    '
    ```

- JavaScript/TypeScript

    ```sh
    systemd-run --quiet --wait --pipe --uid="${user_name}" --machine="${CONTAINER_NAME}" /bin/bash -euc '
    mkdir -p "${HOME}/.local/share/npm/lib"
    '
    ```

## AURヘルパーのインストール

```sh
systemd-run --quiet --wait --pipe --uid="${user_name}" --machine="${CONTAINER_NAME}" /bin/bash -euc '
export CARGO_HOME="${HOME}/.local/share/cargo"
export RUSTUP_HOME="${HOME}/.local/share/rustup"
cd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ~
rm -rf paru
paru -Syyu
'
```

## AURパッケージのインストール

```sh
systemd-run --quiet --wait --pipe --uid="${user_name}" --machine="${CONTAINER_NAME}" /bin/bash -euc '
paru -S --noconfirm \
    oh-my-posh-bin \
    pipes.sh \
    visual-studio-code-bin \
    walk
'
```

## インストール用コンテナの停止

```sh
systemd-run --quiet --wait --pipe --uid=root --machine="${CONTAINER_NAME}" /bin/bash -euc "
rm /etc/sudoers.d/99-${user_name}
"
machinectl stop "${CONTAINER_NAME}"
```

# ブートエントリを変更

```sh
efibootmgr -v

read -rp 'delete boot entry num(ex: 1 2 4): ' -a arr
for i in "${arr[@]}"; do
    efibootmgr -B -b "${i}"
done

efibootmgr -c -d "${install_block_device_path}" -p '1' -l '\EFI\BOOT\BOOTX64.EFI' -L 'Systemd Boot'

read -rp 'boot order num(ex: 4 2 1): ' -a arr
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

# メモ

## firefox

firefoxのハードウェアアクセラレーション対応状況を`about:support`で確認

ハードウェアアクセラレーションが有効になっていない場合は`about:config`で`media.ffmpeg.vaapi.enabled`をtrueにする
