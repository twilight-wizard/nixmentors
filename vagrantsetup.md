Setting up Vagrant
==================

Initial setup
-------------

```bash
mkdir /disk/trump/minerals/virtualbox
vboxmanage setproperty machinefolder /disk/trump/minerals/virtualbox
```

Lab 1
---------

```bash
cd /path/to/nixmentors/repository/Lab1*
vagrant up
```
Note that this will install the base precise64 image into the user's homedir. It will consume 300MB of profile space.
