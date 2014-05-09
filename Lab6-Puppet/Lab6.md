Lab 6: Puppet
=============

Pre-Lab
-------

Puppet is a way to automate configuration of hosts. Before learning Puppet, it is important to know how to configure a host by hand (learn to walk before you can run, so to speak). Make sure you know how to do the following tasks. You can use the VMs provided in this lab, your laptop, or machines in the catacombs. Explicit instructions are not provided, so please take advantage of Google and IRC if you do not know how to do these things.

- Create a user.
- Add the user's public SSH key.
- Create a group. Make the user a part of that group.
- Create a file in /tmp that is owned by the user you created, is readable and executable by the group you created, and is not readable to anyone else.
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

The keyword that configuration management hipsters love to use is **[idempotency](http://en.wikipedia.org/wiki/Idempotence)**. It means that if an action needs to be performed to maintain a certain state, the action will be done. If the system is already in the desired state, Puppet doesn't try to reapply configuration, which might result in errors. This means that you don't get errors from trying to ensure something is the way you want it -- e.g. you don't have to run `service apache2 start` twice, which would result in an error the second time.

### Puppet Code

The Puppet software is written in Ruby. The only reason this is important is because you will need to have an up-to-date version of Ruby installed. Otherwise, you would do best to forget what language it is written in. The Puppet code you will be writing is a **Domain-Specific Language (DSL)**. It is NOT Ruby, nor does it really have many similarities to Ruby. The Puppet language is a **declarative** language. This means that code is written to describe a state without describing how to get there. This contrasts with an **imperative** language, in which the programmer gives instructions or a recipe to tell the computer how to reach some state. The difference will hopefully become more clear after this lab.

### Learning Puppet

Puppet is pretty complicated. Puppet Labs charges a lot of money for three-day long training courses, and that just covers the basics. This lab is meant to get you used to the idea of the Puppet setup, resources, and modules. It's not going to cover everything. Puppet Labs has a great [free tutorial](http://docs.puppetlabs.com/learning) that you can use to cover Puppet more in-depth. It covers Puppet Enterprise, the closed-source version of Puppet, so somethings will be slightly different than what you learn here, but the overall concepts are the same as open-source Puppet and the tutorial is much more complete.

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

It is important to verify this certificate request! Anyone could request a certificate. It's important that certs are only signed for hosts you trust. Make sure the fingerprint next to the host in the list on the master matches the fingerprint that was output on the client.

Sign the certificate with

```
$ sudo puppet cert sign client.local
```

Verify it worked by running the agent again.

We have successfully configured a puppetmaster and client. We now need to write Puppet code to configure our client.

# Resources

Puppet organizes configuration into units called resources. There are many different types of resources. Some examples are:

- a user account
- a group
- a configuration file
- a cron job
- a software package
- a service

The full list of resources Puppet can manage and how it can configure them can be found [in the Puppet documentation](http://docs.puppetlabs.com/references/latest/type.html). You don't need to worry about most of them.

Let's try one out. Let's create a user on our system.

As root, create and open the file `/etc/puppet/manifests/site.pp` **on the puppetmaster** in your editor. Add the following to it:

```
user { 'krinkle':
  ensure     => present,
  comment    => 'krinkle is awesome',
  managehome => true,
  home       => '/home/krinkle',
  shell      => '/bin/bash',
}
```

If you look at the entry for the vagrant user in /etc/passwd, some of these attributes should look familiar. Creating a user resource with Puppet is the same as using the adduser command on an Ubuntu system.

Now apply the configuration to the client. Run:

```
$ sudo puppet agent --test --noop
```

At this point let me point out a few things. The typical mode for a puppet agent is to run as a daemon and check in with the Puppet master every thirty or so minutes to see if new configuration is available. Since we don't want to wait that long for the agent to check in on its own, we run `puppet agent --test` to trigger it right now, and show us the output. We also use the `--noop` flag to tell Puppet to not actually make any real changes *yet*. We want to see the output and make sure it is what we expect before we make any real changes. If we run Puppet without --noop and we realize we've made a mistake, there is not necessarily a simple way to roll back.

If there is a problem with your configuration (such as a syntax error), Puppet will tell you in red.

Once you are sure that you have not made any syntax mistakes and that you are really, really sure you want to create this user, run the agent for real:

```
$ sudo puppet agent --test
```

User krinkle should now exist on the client. You can check by looking in the file `/etc/passwd` or using the command `getent passwd krinkle`. If we had more clients, the Puppet agent on all of them would eventually get this resource from the Puppet master and all the clients would have user krinkle on them.

Let's try another resource. Add the following to the site.pp file on the Puppet master:

```
file { '/tmp/krinklesfile':
  ensure    => file,
  content   => 'This file belongs to krinkle',
  owner     => 'krinkle',
  mode      => '0644',
}
```

This will create a file called /tmp/krinklesfile. It will ensure that the file is a regular file, as opposed to a directory or symlink. It will give it some content. It will give it an owner, and set permissions on it. Run the agent on your client again to make the file come into existence.

Notice that this file resource depended on the user resource already existing. What happens if the user krinkle doesn't exist? Try removing the krinkle user by changing the ensure line to `ensure => absent` in the user resource and running puppet again.

We can't and shouldn't depend on Puppet to figure out this dependency. We can't even depend on Puppet to read the file in order, so it doesn't matter that the user resource was declared before the file resource. (In practice, Puppet can kind of figure this out, but when you have a complex Puppet ecosystem you should not depend on it.) We need to tell Puppet explicitly what depends on what. One way to do this is with the `require` attribute. Change the ensure attribute back to present for the user resource. Then make your file resource look like this:

```
file { '/tmp/krinklesfile':
  ensure    => file,
  content   => 'This file belongs to krinkle',
  owner     => 'krinkle',
  mode      => '0644',
  require   => User['krinkle']
}
```

Notice the capitalized User. Puppet uses this notation when it is wants to refer to a resource that is declared somewhere else. In this case it is looking up its table of users for one called 'krinkle'. It tells Puppet to make sure to create this resource after the 'krinkle' user is created.

Delete the file and the user from your client. Make sure that re-running puppet properly creates the user and the file.

You can do this going the other way. Remove the require line from the file resource, and make your user resource look like this:

```
user { 'krinkle':
  ensure     => present,
  comment    => 'krinkle is awesome',
  managehome => true,
  home       => '/home/krinkle',
  shell      => '/bin/bash',
  before     => File['/tmp/krinklesfile'],
}
```

These two ordering attributes accomplish the same thing. Which one you use depends on what makes sense in a particular context.

There is another syntax for resource ordering, [described in the documentation](http://docs.puppetlabs.com/learning/ordering.html).

# Todo:

- package-file-service, subscribe and notify
- nodes
- directory layout and using the source/content attributes of the file resource
- classes and modules
- defined types
- conditionals and facter

# Post-Lab

- hiera
- mcollective
- puppetdb
- puppetboard
- foreman
- forge
- testing
- custom facts, functions, types, and providers
