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

Lab 4
=====

In this lab you will be debugging broken machines and services.

Setup
-----

```bash
vagrant up
vagrant ssh
```

Section 1: Nagios
-----------------

Nagios is a popular open source monitoring tool designed to let system administrators know about problems in their infrastructure. In this lab Nagios will be monitoring the infrastructure on your vagrant vm.

To get started point your web browser at `http://<your_vm_ip_address>/nagios3`. Then click on "Hosts (Unhandled)". You will see a lot of broken services. Your job is to fix them all by logging into the machine, finding the problem, performing a fix and then checking with Nagios to see if the service turns green.

Section 2: Strategy
-------------------

In no particular order:

* check the logs
* is the service running?
* are the configuration files correct?
* are the correct packages installed?
* are the permissions correct?
* is the file ownership correct?
