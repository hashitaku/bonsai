# 初期設定

```sh
#!/bin/bash -eu
```

# 入力

```sh
read -rsp 'Root Password: ' root_password
read -rp 'User Name: ' user_name
read -rsp 'User Password: ' user_password
```

# ロケールの設定

```sh
sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
locale-gen
localectl set-locale LANG=ja_JP.UTF-8
```

# pacmanの設定

```sh
pacman -Syyu --noconfirm
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sed -i '/Color/c Color' /etc/pacman.conf
```

# root/ユーザー設定

```sh
echo 'change root passwd'
chpasswd <<< "${root_password}"

useradd ${user_name} -m -G wheel,video
echo "change ${user_name} passwd"
passwd ${usera_name} <<< "${user_password}"

pwck -s
grpck -s
```

# sudoの設定

```sh
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel
```

# ユーザー切り替えと設定

```sh
su - ${user_name}

XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
```

# paruのインストール

```sh
cd ~
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si --noconfirm
cd ~
rm -rf paru-bin
paru -Syyu
```

# パッケージインストール

- 基本パッケージのインストール

    ```sh
    paru --noconfirm --asexplicit linux linux-firmware base-devel git
    ```

- Radeonドライバインストール

    ```sh
    paru -S --noconfirm --asexplicit mesa libva-utils xf86-video-amdgpu vulkan-radeon rocm-opencl-sdk rocm-hip-sdk rocm-ml-sdk rocm-smi-lib
    ```

- ミドルウェアのインストール

    ```sh
    paru -S --noconfirm --asexplicit openssh polkit gnome-keyring man-db man-pages arch-install-scripts usbutils nftables bluez bluez-utils libappimage
    ```

- CLIアプリのインストール

    ```sh
    paru -S --noconfirm --asexplicit bash-completion neovim oh-my-posh-bin zip unzip tree wget aria2 jq btop pipes.sh bat ripgrep fd erdtree git-delta neofetch glow
    ```

- デスクトップ環境のインストール

    ```sh
    paru -S --noconfirm --asexplicit xorg-server xorg-xinit xorg-xrandr i3-wm wezterm xclip picom polybar rofi feh dunst libnotify playerctl pipewire pipewire-pulse pipewire-jack wireplumber alsa-utils fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk
    ```

- GUIアプリのインストール

    ```sh
    paru -S --noconfirm --asexplicit seahorse discord visual-studio-code-bin brave-bin gimp vlc thunderbird thunderbird-i18n-ja firefox firefox-i18n-ja gnome-screenshot peek libreoffice-fresh libreoffice-fresh-ja
    ```

- フォントのインストール

    ```sh
    paru -S --noconfirm --asexplicit noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-ubuntu-mono-nerd ttf-inconsolata-nerd
    ```

- 言語処理系

    - C/C++

        ```sh
        paru -S --noconfirm --asexplicit gdb clang lldb libc++ libc++abi cmake meson mesonlsp ninja
        ```

    - Vulkan

        ```sh
        paru -S --noconfirm --asexplicit vulkan-devel
        ```

    - QMK firmware

        ```sh
        paru -S --noconfirm --asexplicit avr-gcc avr-libc arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-newlib dfu-programmer
        ```

    - Rust

        ```sh
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
        ```

    - Python

        ```sh
        paru -S --noconfirm --asexplicit python ruff pyright uv
        ```

    - JavaScript/TypeScript

        ```sh
        paru -S --noconfirm --asexplicit nodejs fnm-bin npm deno typescript typescript-language-server
        test -z "${XDG_DATA_HOME}" && mkdir -p "${XDG_DATA_HOME}/npm/lib"
        ```

    - Lua

        ```sh
        paru -S --noconfirm --asexplicit lua-language-server stylua
        ```

    - Typst

        ```sh
        paru -S --noconfirm --asexplicit typst tinymist
        ```
