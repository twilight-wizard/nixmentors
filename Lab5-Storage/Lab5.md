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

Lab 5: Local/LVM/ZFS/NFS
===================


In this lab, you will be tasked with creating filesystems using dd/LVM/RAID/ZFS


Section 1: Partitioning
-----------------

### dd
dd is the swiss army tool of file-data, we can use dd to create 'fake' block devices
that can be mounted and used elsewhere.

lets create a 1G file that we can use to turn into a (fake) filesystem:

`dd if=/dev/zero of=/destination/file bs=1M count=1G`


### losetup

now you can take the file you just made and associate it with a loopback device.
In layman's terms, it takes the file and maks a block device out of it.
...errr it makes the file look like a hard drive...

`losetup /dev/loop0 /destination/file`


### mkfs.*
You can then make a filesystem on that (fake) device by using mkfs.
mkfs comes with a few built in filesystem types that you can specify after the '.'

let's make an ext4 system on our (fake hdd)

```sh
[root@host ~]# mkfs.ext4 /dev/loop0
mke2fs 1.42.8 (20-Jun-2013)
Discarding device blocks: done
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
32768 inodes, 131072 blocks
6553 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=134217728
4 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304
        
        Allocating group tables: done
        Writing inode tables: done
        Creating journal (4096 blocks): done
        Writing superblocks and filesystem accounting information: done
```


### lsblk
lsblk is a quick and beautiful tool for looking at the filesystem tree.

```sh

[root@fatdadd mnt]# lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda       8:0    0 149.1G  0 disk
├─sda1    8:1    0  46.6G  0 part /
└─sda2    8:2    0 102.5G  0 part /home
loop0     7:0    0   512M  0 loop /mnt
mmcblk0 179:0    0  59.8G  0 disk
```

here is more exapmle output from a more interesting setup.
```sh
-> % lsblk
NAME                                 MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0                                  7:0    0  24.4M  0 loop /srv/node/1
loop1                                  7:1    0  24.4M  0 loop /srv/node/2
sr0                                   11:0    1  1024M  0 rom
sda                                    8:0    0  84.7G  0 disk
├─sda1                                 8:1    0   731M  0 part /boot
├─sda2                                 8:2    0     1K  0 part
└─sda5                                 8:5    0    84G  0 part
  ├─openstack2--vg-root (dm-0)       252:0    0  19.1G  0 lvm  /
  ├─openstack2--vg-var (dm-1)        252:1    0   5.7G  0 lvm  /var
  ├─openstack2--vg-swap_1 (dm-2)     252:2    0   3.8G  0 lvm  [SWAP]
  ├─openstack2--vg-tmp (dm-3)        252:3    0   2.9G  0 lvm  /tmp
  └─openstack2--vg-disk+trump (dm-4) 252:4    0  52.4G  0 lvm  /disk/trump
```

### format
solaris command for determining disks that the kernel can see.

```sh
chandra:~# format
Searching for disks...done


AVAILABLE DISK SELECTIONS:
       0. c1t0d0 <SUN146G cyl 14087 alt 2 hd 24 sec 848>
            /pci@0/pci@0/pci@2/scsi@0/sd@0,0
       1. c1t1d0 <SUN146G cyl 14087 alt 2 hd 24 sec 848>
            /pci@0/pci@0/pci@2/scsi@0/sd@1,0
    Specify disk (enter its number): ctrl-c
```
to do a quick and dirty lookup of the disks (and their names)

### fdisk/cfdisk

These tools are used for creating partitions within a filesystem.

```sh
-> % sudo fdisk -l /dev/sda

Disk /dev/sda: 149.1 GiB, 160041885696 bytes, 312581808 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4b2bb6c8

Device    Boot     Start       End    Blocks  Id System
/dev/sda1           2048  97658879  48828416  83 Linux
/dev/sda2       97658880 312581807 107461464  83 Linux
```

Section 2: LVM
-------------------

### Volume Groups

### Logical Volumes


Section 3: RAID
-------------------

### mdadm


Section 4: ZFS
-------------------

### zpool

### zfs

Section 5: NFS
-------------------

### on the server

### on the client
