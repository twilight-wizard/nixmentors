
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
vagrant ssh
sudo -i
```
Note that this will install the base precise64 image into the user's homedir. It will consume 300MB of profile space.

Teardown
-------------

```bash
# exit vagrant ssh
vagrant halt
```

