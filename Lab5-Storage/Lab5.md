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

`dd if=/dev/zero of=/destination/file bs=1 count=0 seek=1G`

This command should execute rather quickly. We are using a trick with seek, to tell
the system how big it should be without actually going and taking out all of the space.

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
vgcfgbackup    vgchange       vgconvert      vgdb           vgexport       vgimport       vgmerge        vgreduce       vgrename       vgscan
vgcfgrestore   vgck           vgcreate       vgdisplay      vgextend       vgimportclone  vgmknodes      vgremove       vgs            vgsplit
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
lvchange     lvcreate     lvextend     lvmchange    lvmdiskscan  lvmetad      lvmsar       lvremove     lvresize     lvscan
lvconvert    lvdisplay    lvm          lvmconf      lvmdump      lvmsadc      lvreduce     lvrename     lvs
```


Section 3: RAID
-------------------

### What is Raid?

RAID (Redundant Array of Inexpensive Disks) is the ability to combine multiple disks
to attain greater speed/redundancy/both from disk usage. After you RAID together multiple
drives, you then go on and treat them as if the sum total is one drive.

#### Levels of RAID

`RAID 0`

    * Striping
    * Spread the data out over multiple disks
    * Allows for parallel reads on the same file

`RAID 1`

    * Mirroring
    * Creates redundancy, or, makes multiple copies of a file over all disks
    * If a disk goes down, you laugh, and say "But RAID 1"

`RAID 5`

    * Block Level striping w/ parity
    * The file is distributed accross multiple drives, along with parity bits
      that allow the information of a disk to be recalulated in the event of failure
    * Requires at least 3 disks
    * Allows single disk failure

`RAID 10`

    * Combination pizza hut and taco bell
    * Or in technical terms, both RAID 1 and RAID 0 at the same time
    * Example, with four disks, mirror first two, mirror last two and then strip the result

#### Hardware vs Software

You have two choices in howyou do this thing. Either you buy a dedicated card, that does the
RAID, and keeps track of what's going on. OR, you create a software RAID and let the OS keep
track of what to do.

### mdadm
Linux utility for creating software RAIDs

#### RAID Reconnaissance

This file will show you the current status of your local RAID.
It's jam packed full of good info that you will need for debugging and
referencing your RAID setup.

This example shows a system with a RAID0 and is using two devices `sda` and `sdb`
```sh
-> % cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10]
md2 : active raid1 sda[0] sdb[1]
      976631360 blocks super 1.2 [2/2] [UU]
      unused devices: <none> </none>
```

Now that we know the names of the raids used on the system, we can get more details.

`mdadm --detail $RAIDNAME`

```sh
root@russell:~# mdadm --detail /dev/md2
    /dev/md2:
        Version : 1.2
        Creation Time : Sat Apr 27 19:16:17 2013
            Raid Level : raid1
            Array Size : 976631360 (931.39 GiB 1000.07 GB)
        Used Dev Size : 976631360 (931.39 GiB 1000.07 GB)
            Raid Devices : 2
            Total Devices : 2
            Persistence : Superblock is persistent

            Update Time : Fri Jan 24 00:15:48 2014
            State : clean
            Active Devices : 2
            Working Devices : 2
            Failed Devices : 0
            Spare Devices : 0

            Name : ubuntu:2
            UUID : 4032b613:380ebddb:db9a61b0:42f8680a
            Events : 97

            Number   Major   Minor   RaidDevice State
            0       8        0        0      active sync   /dev/sda
            1       8       16        1      active sync   /dev/sdb
```

#### Creating a RAID

That's all fine and dandy. But how make a new RAID?

Section 4: ZFS
-------------------

### zpool

### zfs

Section 5: NFS
-------------------

### on the server

### on the client
