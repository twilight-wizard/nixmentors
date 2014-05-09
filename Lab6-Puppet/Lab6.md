Lab 6: Puppet
=============

Pre-Lab
-------

Puppet is a way to automate configuration of hosts. Before learning Puppet, it is important to know how to configure a host by hand (learn to walk before you can run, so to speak). Make sure you know how to do the following tasks. You can use the VMs provided in this lab, your laptop, or machines in the catacombs. Explicit instructions are not provided, so please take advantage of Google and IRC if you do not know how to do these things.

- Create a user.
- Add the user's public SSH key.
- Create a group. Make the user a part of that group.
- Create a file in /tmp that is owned by the user you created.
- Schedule a cron job to add the line "I am a cron job" to the end of a file every hour.

You can refer to Lab 4 to do these:

- Install the rsyslog package
- Change the rsyslog configuration file
- Restart the rsyslog service

Skip this if you have a working runaway script. You can use the linux lab machines for this (or ask about netgrouplist on IRC):

- Write an SSH for-loop to create a file containing "$USER was here" in /tmp

What is Puppet?
---------------

If you did the pre-lab, you can see that setting up some basic configuration takes a bit of time and effort. On one or two hosts, that's not a big deal. It becomes a problem when you have hundreds or thousands of hosts to manage. The name of the general solution to this problem is **configuration management**. There are several different software products that provide configuration management. Puppet is the configuration management tool used at the CAT.

### Why not use an SSH for-loop to do this?

An SSH for-loop is a sysadmin's Swiss Army knife for Getting Stuff Done. We use it a lot at the CAT. The idea is to write a bash script to SSH in to a number of hosts and do some configuration on each one. This is a basic form of automation, and for many cases, this works great. So what does Puppet get us that SSH for-loops don't?

The keyword that configuration management hipsters love to say is **[idempotency](http://en.wikipedia.org/wiki/Idempotence)**. It means that if an action needs to be performed to maintain a certain state, the action will be done. If the system is already in the desired state, Puppet doesn't try to reapply configuration, which might result in errors. This means that you don't get errors from trying to ensure something is the way you want it -- e.g. you don't have to run `service apache2 start` twice, which would result in an error the second time.

### Puppet Code

The Puppet software is written in Ruby. The only reason this is important is because you will need to have an up-to-date version of Ruby installed. Otherwise, you would do best to forget what language it is written in. The Puppet code you will be writing is a **Domain-Specific Language (DSL)**. It is NOT Ruby, nor does it really have many similarities to Ruby. The Puppet language is a **declarative** language. This means that code is written to describe a state without describing how to get there. This contrasts with an **imperative** language, in which the programmer gives instructions or a recipe to tell the computer how to reach some state. The difference will hopefully become more clear after this lab.

# Setting Up a Master and Agent

Bring up your two machines in the Lab6-Puppet directory.

```
$ vagrant up
```

SSH in to both of them. It will probably be helpful to have two terminal windows open.

```
$ vagrant ssh puppetmaster
$ vagrant ssh client
```

## Configure DNS

Add the following to your /etc/hosts file on the puppetmaster:

```
192.168.1.11 client.local client
```

Add the following to your /etc/hosts file on the client:

```
192.168.1.10 puppet.local puppet
```

Add the PuppetLabs apt repository to the master and client:

```
$ wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
$ sudo dpkg -i puppetlabs-release-precise.deb
$ sudo apt-get update
```

Install the puppetmaster

On the puppetmaster machine, install the puppetmaster and a webserver:
```
$ sudo apt-get install puppetmaster-passenger
```

The Puppet client-server model is a lot like the Apache client-server model. The Puppet master runs a web server. Puppet clients run a daemon, called an agent, that periodically makes web requests to the Puppet master. Installing puppetmaster-passenger automatically installs Apache and configures a vhost for us.

On the client, install the puppet agent:

```
$ sudo apt-get install puppet
```

The client needs to request a certificate from the master. By default, it will automatically request a certificate the first time the agent runs. Trigger it by running

```
$ sudo puppet agent --test
```

View outstanding certificate requests on the master with

```
$ sudo puppet cert list
```

It is important to verify this certificate request! Anyone could request a certificate. It's important that certs are only signed for hosts you trust.

Sign the certificate with

```
$ sudo puppet cert sign client.local
```

Verify it worked by running the agent again.

We have successfully configured a puppetmaster and client. We now need to write Puppet code to configure our client.

# Todo:

- resources
- package-file-service
- nodes
- directory layout and using the source/content attributes of the file resource
- classes and modules
- defined types
- conditionals and facter

# Post-Lab

hiera
mcollective
puppetdb
puppetboard
foreman
forge
testing
custom facts, functions, types, and providers
