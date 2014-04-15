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

Lab 3: NFS/LDAP/DNS
===================


In this lab you will be playing with NFS, the Network File System; LDAP, the Leightweight Directory Access Protocol, and DNS; the Domain Name Service. These are kindof the hardcore services. For Realz. Dis aint the Web Dump, homie.


Section 1: Networking Basics
----------------------------


For this lab we will have a multi-vm setup inside vagrant. All three vms will be running Centos Linux. Each will have its own IP Address.



Take a quick look at your vagrantfile:

This file can be your reference for which machines have which names and ip addresses.


### Vagrant up

```shell
vagrant up
```

```shell
hadron:Lab3-NFS-LDAP-DNS (master) $ vagrnt status
zsh: correct 'vagrnt' to 'vagrant' [nyae]? y
Current machine states:

nfsserver                 running (virtualbox)
nfsclient1                running (virtualbox)
nfsclient2                running (virtualbox)
nfsclient3                running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

### SSH into multiple hosts

Open up several terminal windows, change directory on all of them into the Lab3 directory.

```shell
vagrant ssh nfsserver
```

And in a different window:


```shell
vagrant ssh nfsclient1
```

### Exercises

#### Basic networking verification and warm up

* Ping each host from one host

```shell
hadron:Lab3-NFS-LDAP-DNS (master) $ vagrant ssh nfsserver
Last login: Tue Apr 30 21:45:04 2013 from 10.0.2.2
Welcome to your Vagrant-built virtual machine.
vagrant@nfsserver: ~ > ping nfsclient1
ping: unknown host nfsclient1
vagrant@nfsserver: ~ > ping 192.168.1.11
PING 192.168.1.11 (192.168.1.11) 56(84) bytes of data.
64 bytes from 192.168.1.11: icmp_seq=1 ttl=64 time=0.283 ms
64 bytes from 192.168.1.11: icmp_seq=2 ttl=64 time=0.268 ms
^C
--- 192.168.1.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1611ms
rtt min/avg/max/mdev = 0.268/0.275/0.283/0.018 ms
```

* View the routing table for your virtual machines

```
vagrant@nfsserver: ~ > netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth1
10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 eth0
169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth0
169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth1
0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 eth0
````


* Set up three users on nfsserver and nfsclient1, nfsclient2, and nfsclient3
- ashley: uid=2313
- bob:    uid=2121
- mike:   uid of your choice

```shell
sudo useradd -u 2313 ashley
sudo useradd -u 2121 bob
sudo useradd -u $UID mike
```

* Set passwords for the users (including root)

```shell
sudo passwd $USERNAME
```

* Create a file foo.txt with plain text in it, and copy it using scp from one host to another using your created users

As each of the users you just created (on any host), create a file foo.txt and send it to different hosts (have destinations be different for each file)
```shell
sudo su $USERNAME (not just for becoming root 0.0)
touch foo.txt
scp $FILE_TO_SEND $USERNAME@$DEST_IP:$DEST_PATH

#Leaving out the username will use the user logged in as by default
#ip address can be replaced with hostname if set
#Leaving out the $DEST_PATH will use /home/$USER by default
```
Verify that the file was sent successfully by running ``ls /home/$USER`` on the destination host.

Run ``exit`` to go back to root user

* Set up a hosts file on nfs_server to map each ip address in your network to the common name given in the vagrant file.

Add the following lines to /etc/hosts
```shell
192.168.1.10 nfsserver
192.168.1.11 nfsclient1
192.168.1.12 nfsclient2
192.168.1.13 nfsclient3
```
Try to ping one of the other hosts by hostname. You should get the same output you would if you pinged by ip addresses.

* Copy that hosts file to nfsclient1

```shell
sudo scp $USERNAME@nfsclient1:/etc/hosts

#scp overwrites an existing file if one with the same name is found in the destination path
```
Remove the line with the nfs server ip address in /etc/hosts of nfsserver
On nfsclient1, remove ``nfsserver.local nfsserver`` from the line with the localhost ip address in /etc/hosts
Send the /etc/hosts from nfsclient1 to clients 2 and 3
On each client, add their hostname to the localhost ip address and remove the respective lines with their own ip addresses
```shell
#EX: nfsclient1 /etc/hosts should look like this
127.0.0.1 nfsclient1 localhost localhost.localadmin localhost4 localhost4.localdomain4
192.168.1.12 nfsclient2
192.168.1.13 nfsclient3
```


Section 2: NFS: The Network File System
---------------------------------------

NFS, above all other *nix services, is the core of what the CAT does. Since the dawn of multisystem networking janaka and his minions have been carving space off of the big iron and exporting it to the puny clients.

On a conceptual level, NFS is one computer letting another computer use its storage space. It is also one-to-many, meaning that one NFS server can export a filesystem and many client computers can mount and utilize this file system.


### Setting up the NFS packages

* Install the NFS packages
```shell
yum install nfs-utils
```

* Start the daemon

```shell
sudo service nfs start
```

* Create directories /data/share1 through /data/share7 on nfsserver

```shell
mkdir /data
mkdir /data/share1
mkdir /data/share2
mkdir /data/share3
mkdir /data/share4
```
Make some files in these shares on nfsserver
```shell
touch /data/share1/file1
touch /data/share2/file2
touch /data/share3/file3
touch /data/share4/file4
```
Change the perms on the directories so anybody can create and edit files on them
```shell
root@nfsserver: data > chmod 777 /data/share*
```

### /etc/exports

The NFS server is configured by a file called /etc/exports. This file tells the nfs server which directories to export and which machines to export them to. NFS, on its own, does not do per-user authentication. Rather any machine in the access list can mount the remote filesystem with the options given in /etc/exports.

You can read about /etc/exports at http://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-nfs-server-config-exports.html

### Setting up NFS configs

* Open nfs and tcp/udp ports on nfsserver for the ip addresses of the clients

We need to open ports 2049 (default port for nfs) and 111 (default port for portmapper) to allow tcp/udp protocols on our subnet

Run these commands on nfsserver
```shell
sudo iptables -I INPUT -p tcp -s 192.168.1.0/24 -m state --state NEW,RELATED,ESTABLISHED --dport 2049 -j ACCEPT
sudo iptables -I INPUT -p udp -s 192.168.1.0/24 -m state --state NEW,RELATED,ESTABLISHED --dport 2049 -j ACCEPt
sudo iptables -I INPUT -p tcp -s 192.168.1.0/24 -m state --state NEW,RELATED,ESTABLISHED --dport 111 -j ACCEPT
sudo iptables -I INPUT -p udp -s 192.168.1.0/24 -m state --state NEW,RELATED,ESTABLISHED --dport 111 -j ACCEPT
```

Save the changes and restart the service
```shell
sudo service iptables save
sudo service iptables restart
```

* Set the directory /data/share1 to be shared with standard permissions to all hosts

Add the following lines to /etc/exports on nfsserver
```shell
/data/share1 *(rw)
```
Execute ``exportfs -rv`` on nfs_server

* Mount the filesystem on nfs_client_1

```shell
root@nfsclient1: ~ > mount -t nfs nfs_server:/data/share1 /mnt
```
Check if you can see file1
```shell
ls /mnt
```
su into another user and try to make a file on the mounted filesystem
```shell
touch /mnt/testfile
```
Now mount share1 on another nfs_client. Can you see testfile there?
su into the same user and edit the file. Go back to nfs_client_1 and look at the file. Can you see the changes?

Dont forget to unmount the filesystems when you are done with them
```shell
umount /mnt
```

* Share /data/share2 to only nfs_client_2

Add this to /etc/exports on nfsserver
```shell
/data/share2 nfsclient2(rw)
```
Execute ``exportfs -rv`` on nfs_server
Try mounting share2 on a nfsclient other than client2. Does it work? (it shouldnt)
Now try mounting share2 on nfs_client2. Does this work? If no error messages pop up, check if you can see file2.

Unmount the FS when you are done with it.
* Share /data/share3 to only clients in the 192.168.1.0/24 subnets

Add this to /etc/exports on nfsserver
```shell
/data/share3 192.168.1.0/24(rw)
```
Execute ``exportfs -rv`` on nfs_server
Now try mounting share3 on all of the nfsclients . Does this work? If no error messages pop up, check if you can see file3.

Unmount share3 from all of the clients.
* Share /data/share4 to all clients in your subnet but no other ip addresses, but turn off root squashing
Add this to /etc/exports on nfsserver
```shell
/data/share4 192.168.1.0/24(rw,no_root_squash)
```
Run ``exportfs -rv`` on nfsserver
Mount share4 on any nfs_client. Trying making a file as root on the share. Run ``ls -l``. Who is the owner of the file (with root squashing on, it should be "nobody")

### Exercises 

* On the clients, verify that you can create a file on an NFS share with one user, and pull it off with another user on another system
* On one client, create a large file and open it with vim. On another client, rm the file. What happens?


Section 3: LDAP Client connection
---------------------------------------

Section 4: DNS
---------------------------------------

