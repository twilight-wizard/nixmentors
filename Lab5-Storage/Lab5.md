<!---
   Copyright 2014 Portland State University

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

Lab 5: Storage
===================


In this lab, you will be tasked with creating filesystems on Solaris and Linux.


Section 1: ZFS
-------------------

Okay, Welcome all of y'all to the most important event of your entire life, ever.
ZFS once stood for Zetabyte File System, but no longer means anything anymore.
We (and a lot of other companies) use ZFS for our most critical File system needs.
The best part of ZFS is that it is all software defined storage, and highly configurable.
We can define what we want wit code, and ZFS sees to it that it will be done.

### Create a zpool

#### Figure out which disks are on the system

```bash
# TODO, add explanation and output
format
```

#### zpool create

```bash
# FIXME: Fill in the args
zpool create tank
```

### Create a zfs filesystem

```bash
zfs create tank/media
```

### Enable zfs snapshots

```bash
# TODO: wren plz pre-install package so they don't have to wait for ages
```

### Set the refquota to 5G

```bash
zfs set refquota=5G tank/media
```

### Create a user janaka and a group cats


```
# TODO, or should this be in vagrant already?
```

### Set the owner of the the filesystem to janaka and the group to cats

```bash
chown $user:$group /tank/media
```

### Set the permissions to owner/group rwx with sticky bit

```
chmod 2770 /tank/media
```

### Enable NFS


```bash
zfs set share.nfs=on tank/media
```

### Restrict to the linux client IP addr

```bash
zfs set share.nfs.sec.default.rw=$CLIENT_IP_ADDR tank/media
```

### Mount /tank/media on the Linux client

#### mount

```
# TODO
mount
```

#### Verify user janaka can read/write

#### Verify users in group cat can read/write

#### Verify users not in group cat cannot read/write


### zfs send / recv


Section 2: Linux Filesystems
----------------------------


### Make an LVM volume

### Create an ext4 filesystem on that volume
