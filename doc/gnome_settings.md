# GNOME設定

- gnome-shellのテーマを入れる場合gnome-shell-extensionをブラウザの拡張機能として入れる

## ホームディレクトリのフォルダを英語表記にする

```sh
$ env LC_ALL=C xdg-user-dirs-gtk-update --force
```

を入力後、`二度と同じ質問をしない`を選択し`Update Names`を押す。

## スクリーンショットのキーボードショートカットを作成

設定を開く -> キーボードショートカット -> 追加

- 全画面スクリーンショット
    - `$ gnome-screenshot`
    - `ctrl + shift + F1`

- 範囲指定スクリーンショット
    - `$ gnome-screenshot --area`
    - `ctrl + shift + F2`

## スクリーンショットの保存場所変更

```sh
$ gsettings set org.gnome.gnome-screenshot auto-save-directory '$HOME/Desktop'
```

## マウス設定

マウスアクセラレーションの変更

```sh
$ gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
```

マウスセンシの変更

```sh
$ gsettings set org.gnome.desktop.peripherals.mouse speed '0.0'
```

## デスクトップの壁紙を変更

単色

```sh
$ gsettings set org.gnome.desktop.background picture-uri ''
$ gsettings set org.gnome.desktop.background primary-color '#6c848d'
```

## ウィンドウ削除ボタンなどを左上に移動

```sh
$ gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
```

## dockを下に配置

```sh
$ gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
```

## ゴミ箱をデスクトップから消してDockに追加

```sh
$ gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true
$ gsettings set org.gnome.shell.extensions.ding show-trash false
```

## Dockの設定

```sh
$ gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
$ gsettings set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false
$ gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
$ gsettings set org.gnome.shell.extensions.dash-to-dock force-straight-corner false
```

## デスクトップからホームを削除

```sh
$ gsettings set org.gnome.shell.extensions.ding show-home false
```

## nautilsで隠しファイルを表示する

```sh
$ gsettings set org.gnome.nautilus.preferences show-hidden-files true
$ gsettings set org.gtk.Settings.FileChooser show-hidden true
```

## アイコン、テーマを変更

```sh
$ mkdir ~/{.icons,.themes}
$ gsettings set org.gnome.desktop.interface gtk-theme 'gtk-theme-name'
$ gsettings set org.gnome.desktop.interface icon-theme 'gtk-icon-theme-name'
$ gsettings set org.gnome.desktop.interface cursor-theme 'gtk-cursor-theme-name'
```

`org.gnome.desktop.wm.preferences theme`の設定は無視されGTKのテーマが使われる

それぞれのディレクトリにアイコンとテーマを入れる。

## GnomeTerminalの設定

__`dconf editor`を使ったほうが簡単__

### プロファイルのUUID確認

```sh
$ gsettings get org.gnome.Terminal.ProfilesList list
```

### フォント設定

`fc-list(1)`での名前を設定する

Ubuntu Mono Boldの場合

```sh
$ gsettings set /org/gnome/terminal/legacy/profiles:/:UUID/bold-is-bright true
$ gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:UUID/ use-system-font false
$ gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:UUID/ font 'Ubuntu Mono Bold 14'
```

### ウィンドウサイズ設定

```sh
$ gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:UUID/ default-size-columns 100
$ gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:UUID/ default-size-rows 30
```
