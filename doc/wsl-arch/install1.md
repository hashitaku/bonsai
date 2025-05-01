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
sed -i '/Parallel/c ParallelDownloads = 5' /etc/pacman.conf
sed -i '/Color/c Color' /etc/pacman.conf
pacman -Syyu --noconfirm
pacman -S --noconfirm --asexplicit linux linux-firmware base-devel git
```

# root/ユーザー設定

```sh
echo 'change root passwd'
echo "root:${root_password}" | chpasswd

useradd "${user_name}" -m -G wheel,video
echo "change ${user_name} passwd"
echo "${user_name}:${user_password} | chpasswd

pwck -s
grpck -s
```

# sudoの設定

```sh
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
visudo -csf /etc/sudoers.d/wheel
```
