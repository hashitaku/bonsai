# PVEを操作するスクリプト集

## VMの作成

`pvesh`を使用することで次の`VM_ID`を取得可能

```sh
VM_ID="$(pvesh get /cluster/nextid)"
VM_NAME='VM_NAME'
VM_CORE='2'
VM_MEMORY='2048'
ISO_NAME='ISO_NAME'

qm create "${VM_ID}" \
--name "${VM_NAME}" \
--cpu 'host' \
--cores "${VM_CORE}" \
--memory "${VM_MEMORY}" \
--bios 'ovmf' \
--machine 'q35' \
--ostype 'l26' \
--net0 'virtio,bridge=vmbr0' \
--boot 'order=ide2;scsi0' \
--efidisk0 'local-lvm:1' \
--scsihw 'virtio-scsi-single' \
--scsi0 'local-lvm:50,discard=on' \
--cdrom "local:iso/${ISO_NAME}"
```

VMのセットアップが完了した後にISOと紐づいた`ide2`を外す

```sh
qm set "${VM_ID}" --delete ide2
```
