# debianインストール

## インストールメディア作成

- ノートPCなどのプロプライエタリドライバが入っている物と完全にフリーライセンスで構成されたISOは別に分けられている。

- 例(debian-11.2の場合)
    - https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/11.2.0+nonfree/amd64/iso-cd/firmware-11.2.0-amd64-netinst.iso

## パーティション

- 512MB EFIパーティション
- 4G Swapパーティション(swapが必要性は要検討)
- 残り ext4パーティション

## EFIパーティションを複数存在させる場合

- インストールでEFIパーティションの位置を指定できないのでgrubを再インストールする必要がある

- 修正方法1
    - https://wiki.ubuntulinux.jp/UbuntuTips/Others/ReinstallGrub2
- 修正方法2
    - GpatedでインストールしてほしくないEFIパーティションのbootフラグを一時的に削除してからインストールする

`efibootmgr(8)`や`fstab(5)`要確認

# GRUB設定

## ブートスプラッシュ

ブートスプラッシュをCLIにしたい場合は`/etc/default/grub`を以下のように編集後`update-grub`実行

```
# GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""
```

`kernel-command-line(7)`要参照

## GRUBの他OS検索

他のOSを検索してGRUBのメニューエントリに追加する機能をOFFにする

`/etc/default/grub`を編集

`GRUB_DISABLE_OS_PROBER=true`を追加し`update-grub`実行

## インストール

最小構成でインストールするためxorgなどのデスクトップ環境やユーティリティなどの選択を解除する

# 初期設定

## ネットワーク設定

### wifiを使用する場合wpa_supplicantを設定する

```
# wpa_passphrase "SSID" "passphrase" > /etc/wpa_supplicant/wpa_supplicant-"interface".conf
# systemctl start wpa_supplicant@"interface".service
# systemctl enable wpa_supplicant@"interface".service
```

### systemd-networkdの設定(ファイル名に注意)

- 無線(/etc/systemd/network/50-wireless.network)

    ```
    [Match]
    Name = interface

    [Network]
    DHCP = yes
    ```

- 有線(/etc/systemd/network/50-wired.network)

    ```
    [Match]
    Name = interface

    [Network]
    DHCP = yes
    ```

- systemd-networkdを有効化

    ```
    # systemctl start systemd-networkd.service
    # systemctl enable systemd-networkd.service
    ```

## sudo設定

```
# apt install sudo
# usermod -a -G sudo USER
```

# 全般設定、開発環境のインストールなど

## インストールするパッケージ

- curl
- wget
- build-essential
- git
- bash-completion
- zip
- tree
- file

```sh
$ sudo apt install curl wget build-essential git bash-completion zip tree file
```

## linuxbrewのインストール

```sh
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ctrl-Dでホームディレクトリの下にインストールする

- homebrewでインストールするもの
    - micro
    - cmake
    - meson
    - clang-format

## rustupのインストール

```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## sshの設定

```sh
$ ssh-keygen -t ed25519 -C "mail"
```

- ~/.ssh/config

    ```
    Host github
	    HostName github.com
	    IdentityFile ~/.ssh/id_ed25519
	    User git
    ```

# nvidiaドライバインストール

## MOKの設定

- 鍵と証明書の生成

    ```sh
    $ sudo openssl req -new -x509 -newkey rsa:2048 -keyout '/root/mok.priv' -outform DER -out '/root/mok.der' -days 36500 -nodes -subj '/CN=DKMS MOK/'
    ```

- MOK登録
    - 以下のコマンドを入力後ワンタイムキーを求められるので次回ブート時に入力

        ```sh
        $ sudo mokutil --import '/root/mok.der'
        ```

## グラフィックカードのドライバをインストール

1. CUDA toolkitを公式サイトからdeb(network)を選ぶ
1. apt-keyが非推奨なので以下のコマンドを実行

    ```sh
    $ distribution="$(source /etc/os-release; echo $ID$VERSION_ID)" && curl -fsSL "https://developer.download.nvidia.com/compute/cuda/repos/${distribution}/x86_64/7fa2af80.pub" | sudo gpg --dearmor -o '/usr/share/keyrings/nvidia_cuda-archive-keyring.gpg'

    $ distribution="$(source /etc/os-release; echo $ID$VERSION_ID)" && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/nvidia_cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/${distribution}/x86_64/ /" | sudo tee '/etc/apt/sources.list.d/nvidia_cuda.list'
    ```

1. `sudo apt install cuda-drivers`とすればドライバ類がインストールされる

1. カーネルモジュールを自動で署名するためにdkmsを設定

    ```sh
    $ echo 'sign_tool="/etc/dkms/sign_helper.sh"' | sudo tee -a '/etc/dkms/framework.conf'
    ```

1. カーネルモジュールのリビルド

    - 一度dkmsの状況を確認

        ```sh
        $ sudo dkms status
        ```

    ```
    $ sudo dkms remove module-name/module-version --all
    $ sudo dkms add module-name/module-version
    $ sudo dkms autoinstall
    ```

1. 参考文献

- [技評のapt-key解説記事](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0675)
- [技評のsources.list解説記事](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0677)
- [技評のubuntu向けセキュアブート解説記事](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0444)
- [Debian wiki - secureboot](https://wiki.debian.org/SecureBoot)
- [Dell github - dkms](https://github.com/dell/dkms)
- [Arch Linux Wiki JP - DKMS](https://wiki.archlinux.jp/index.php/Dynamic_Kernel_Module_Support)
- `man dkms(8)`
- `man moktuil(1)`

# デスクトップ環境の設定

## 必要なパッケージのインストール

```sh
$ sudo apt install xorg picom kitty pulseaudio alsa-utils fonts-noto fcitx5-mozc
$ sudo apt install i3lock-fancy polybar feh dunst light
```

```sh
# i3-gaps
$ sudo apt install libstartup-notification0 libxcb-xkb1 libxcb-xinerama0 libxcb-randr0 libxcb-cursor0 libxcb-keysyms1 libxcb-icccm4 libxcb-xrm0 libxkbcommon0 libxkbcommon-x11-0 libyajl2 libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libev4
# rofi
$ sudo apt install libgdk-pixbud-2.0-0 libxcb-ewmh2
# xob 
$ sudo apt install libconfig9
```

## デスクトップ環境のビルド

### ビルド環境構築

```sh
$ sudo apt install mmdebstrap systemd-container
$ sudo mmdebstrap --components=main --variant=buildd bullseye buildfs
$ sudo systemd-nspawn -D buildfs
```

以下chroot内

### ビルドに必要なライブラリのインストール

```
# apt install git cmake meson libconfig-dev dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm-dev libxcb-shape0-dev libgdk-pixbuf-2.0-dev libxcb-ewmh-dev flex bison
```

### i3-gapsのビルド

```
# git clone https://github.com/Airblader/i3.git
# cd i3
# meson build --prefix=${HOME}/local && cd build
# ninja install
```

### rofiのビルド

```
# git clone
# cd rofi
# meson build --prefix=${HOME}/local && cd build
# ninja install
```

### xobのビルド

```
# git clone https://github.com/florentc/xob.git
# cd xob
# prefix=${HOME}/local make install
```

### ビルドした物のインストール

`buildfs`から`local`ごと`cp`してくる。

その時`sudo chowm -R ${USER}:${USER} proj`をするとファイルの所有者と所有グループを再帰的に変更できる。

### 参考

- https://gihyo.jp/admin/serial/01/ubuntu-recipe/0686
- https://unix.stackexchange.com/questions/198590/what-is-a-bind-mount

## フォントの設定

- 例: ubuntu mono

    ```sh
    $ mkdir ~/.fonts
    $ wget https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
    $ unzip 0cef8205-ubuntu-font-family-0.83.zip
    $ mv ./ubuntu-font-family-0.83/*.ttf ~/.fonts
    ```

`~/.fonts`にttfファイルを入れてくる

`fc-list(1)`で環境にあるフォントを一覧で見れる

## PulseAudio設定

異なるサンプリングレートの音声(discord: 44100hz, firefox: 48000hz)を同時に再生すると不具合が出る場合がある。

`/etc/pulse/daemon.conf` または `~/.config/pulse/daemon.conf`に以下を追加することで回避できる。

```
avoid-resampling = yes
resample-method = soxr-vhq
default-sample-rate = 48000
alternate-sample-rate = 48000
```

## ブラウザのインストール

```sh
$ sudo curl -fsSLo '/usr/share/keyrings/brave-browser-archive-keyring.gpg' 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg'

$ echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main' | sudo tee '/etc/apt/sources.list.d/brave-browser-release.list'

$ sudo apt install brave-browser
```

## DropBox

```sh
$ cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
$ ~/.dropbox-dist/dropboxd
```

ブラウザが起動するのでログインする

__DropBoxの同期が三台までなのでリンクされている機器を要確認__

## VSCode

```sh
$ curl -fsSL 'https://packages.microsoft.com/keys/microsoft.asc' | sudo gpg --dearmor -o '/usr/share/keyrings/microsoft-vscode-archive-keyring.gpg'
$ echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-vscode-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main' | sudo tee '/etc/apt/sources.list.d/vscode.list'
```

- https://code.visualstudio.com/docs/setup/linux#_installation

## バックライトの設定

```sh
$ light -N 5 -s sysfs/backlight/auto
```

- https://unix.stackexchange.com/questions/281858/difference-between-xinitrc-xsession-and-xsessionrc

### 環境変数

- ~/.config/enviroment.d/*.conf

    systemd依存だから.profileのほうが良い？
