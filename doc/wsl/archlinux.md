# WSL2のArchLinuxのインストール手順

## 初期設定

```sh
#!/bin/bash -eu
```

## 設定項目の入力

```sh
read -rp 'User Name: ' user_name
read -rsp 'User Password: ' user_password1; echo;
read -rsp 'User Password again: ' user_password2; echo;
read -rp 'Hostname: ' hostname

if [[ -z "${user_name}" ]]; then
    echo "User is empty"
    false
fi

if [[ "${user_password1}" != "${user_password2}" ]]; then
    echo 'User Password do not match'
    false
fi
```

## 必要なパッケージのインストール

```sh
pacman -Syyu
pacman -S base-devel git
```

## ユーザーの追加

```sh
useradd ${user_name} -m -G wheel,video
echo "change ${user_name} passwd"
echo "${user_name}:${user_password}" | chpasswd

pwck -s
grpck -s
```

## sudoersの設定

```sh
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel
```

## pacmanの設定

```sh
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sed -i '/Color/c Color' /etc/pacman.conf
```

## タイムゾーンの設定

```sh
timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true
```

## ロケール設定

```sh
sed -i '/ja_JP.UTF-8/c ja_JP.UTF-8 UTF-8' /etc/locale.gen
locale-gen
localectl set-locale LANG=ja_JP.UTF-8
```

## ホストネーム設定

```sh
sudo hostnamectl hostname "${hostname}"
```

## wsl.confの作成

```sh
echo '[boot]
systemd = true

[interop]
appendWindowsPath = false

[network]
hostname = WSL2

[user]
default = hashitaku' | tee /etc/wsl.conf
```

## ユーザーへログイン

```sh
su - "${user_name}"
```

## AURヘルパーのインストール

```sh
cd ~
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si --noconfirm
cd ~
rm -rf paru-bin
paru -Syyu
```

## パッケージインストール

- ミドルウェアのインストール

    ```sh
    paru -S --noconfirm --asexplicit openssh polkit gnome-keyring man-db man-pages arch-install-scripts nftables libappimage
    ```

- CLIアプリのインストール

    ```sh
    paru -S --noconfirm --asexplicit bash-completion neovim oh-my-posh-bin zip unzip tree wget aria2 jq btop pipes.sh bat ripgrep fd fzf erdtree git-delta neofetch glow walk
    ```

- デスクトップ環境のインストール

    ```sh
    paru -S --noconfirm --asexplicit xorg-server xorg-xinit xorg-xrandr xclip pipewire pipewire-pulse pipewire-jack wireplumber alsa-utils fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk
    ```

- GUIアプリのインストール

    ```sh
    paru -S --noconfirm --asexplicit visual-studio-code-bin firefox firefox-i18n-ja
    ```

- フォントのインストール

    ```sh
    paru -S --noconfirm --asexplicit noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-ubuntu-mono-nerd ttf-inconsolata-nerd
    ```

- 開発環境のインストール

    ```sh
    paru -S --noconfirm --asexplicit docker docker-buildx docker-compose
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

    - Rust

        ```sh
        CARGO_HOME="${XDG_DATA_HOME}/cargo"
        RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
        ```

    - Python

        ```sh
        paru -S --noconfirm --asexplicit python ruff pyright uv
        ```

    - JavaScript/TypeScript

        ```sh
        paru -S --noconfirm --asexplicit nodejs fnm-bin npm deno typescript typescript-language-server
        test -n "${XDG_DATA_HOME}" && mkdir -p "${XDG_DATA_HOME}/npm/lib"
        ```

    - Lua

        ```sh
        paru -S --noconfirm --asexplicit lua-language-server stylua
        ```

    - Typst

        ```sh
        paru -S --noconfirm --asexplicit typst tinymist
        ```

## WSLgの設定

```sh
ln -s /mnt/wslg/runtime-dir/wayland-0 /run/user/"$(id -u)"/
```
