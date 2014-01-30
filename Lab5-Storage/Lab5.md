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

So to make a pool, you need three things, a name, a pooling strategy, and
a list of devices to pool together.

* Name
    * The name of the pool
* Pool Strategy
    * How you want to arrange the 'disks' together
* Devices
    * This can be 'real' devices, or even pseudo devices (like loopback files)

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
# svcs -av  | grep snap
disabled       -             Dec_19           - svc:/system/filesystem/zfs/auto-snapshot:frequent
disabled       -             Dec_19           - svc:/system/filesystem/zfs/auto-snapshot:hourly
disabled       -             Dec_19           - svc:/system/filesystem/zfs/auto-snapshot:monthly
disabled       -             Dec_19           - svc:/system/filesystem/zfs/auto-snapshot:weekly
disabled       -             Dec_19           - svc:/system/filesystem/zfs/auto-snapshot:daily
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

### Set the permissions to owner/group rwx with guid bit

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

#### What is LVM?

LVM (logical Volume Manager) is a software based partitioning system that is
much more modern and flexible compared to traditional partitioning practices.
Specifically, the creation, deletion, and resizing of a partition is much easier
to do, after the system is loaded and running.

### Volume Groups

All of the commands that deal with Volume groups are prefixed with the letters
'vg' thus, if your tab-completion is awesome, you can vg<tab><tab> to get a quick
and dirty look at all of the handy commands.

```sh
-> % vg
vgcfgbackup    vgchange       vgconvert      vgdb           vgexport
vgimport       vgmerge        vgreduce       vgrename       vgscan
vgcfgrestore   vgck           vgcreate       vgdisplay      vgextend
vgimportclone  vgmknodes      vgremove       vgs            vgsplit
```

#### Oh right... but what is a volume group?

A volume group is a sectionof disk that will contain your logical volumes.
You can think of it like a single partiton on disk, that will house multiple
software defined containers.

#### Create a Volume Group
#### List your Volume Groups
#### Delete a Volume Group

### Logical Volumes


```sh
-> % lv
lvchange     lvcreate     lvextend     lvmchange    lvmdiskscan
lvmetad      lvmsar       lvremove     lvresize     lvscan
lvconvert    lvdisplay    lvm          lvmconf      lvmdump
lvmsadc      lvreduce     lvrename     lvs
```

