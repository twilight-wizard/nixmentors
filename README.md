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

Nix Mentor Sessions
===================

This repository is home to the materials used in the Nix Mentor Sessions run by [theCAT](http://cat.pdx.edu) for the 2014 [Braindump](http://braindump.cat.pdx.edu) year.


Sessions
--------

* Lab 1: [Intro to Vagrant and Intro to Web](Lab1-Intro-Web-Vagrant/Lab1.md)
* Lab 2: [Databases and Advanced web](Lab2-Databases/Lab2.md)
* Lab 3: [NFS/LDAP/DNS](Lab3-NFS-LDAP-DNS/Lab3.md)
* Lab 4: [Debugging](Lab4-Debugging/Lab4.md)
* Lab 5: [Storage](Lab5-Storage/Lab5.md)

Cloning a Repository
====================

```bash
git clone https://github.com/pdxcat/nixmentors.git
cd nixmentors
cd Lab#-something-something
```

Setting up Vagrant
==================

Initial setup
-------------

```bash
mkdir -p /disk/trump/minerals/$USER
vboxmanage setproperty machinefolder /disk/trump/minerals/$USER
```

Clone the Repo
--------------

```bash
git clone https://github.com/pdxcat/nixmentors.git
cd nixmentors
```

Lab 1
---------

```bash
cd /path/to/nixmentors/repository/Lab1*
vagrant up
vagrant ssh
sudo -i
```
Note that this will install the base precise64 image into the user's homedir. It will consume 300MB of profile space.

If you have been alumnified, this will fail because there's not enough space. You can store the image somewhere else instead. Add the following environment variable to your .whateverrc:

    export VAGRANT_HOME=/disk/trump/minerals/$USER

Note that if you try to do `vagrant up` on multiple machines, you will probably get an error about an inaccessible vm. If that happens, do like so:

    VBoxManage list vms

You'll see a line identifying a vm that's inaccessible, and a hash to identify it. Take that entire hash (minus the curly braces), and run this:

    VBoxManage unregistervm <hash>


Teardown
-------------

```bash
# exit vagrant ssh
vagrant halt
```

