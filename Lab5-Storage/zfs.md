ZFS
===

A wise man once said:

"ZFS? I hardly knew her..."

You all today will become greater than that man.


What is ZFS?
------------

ZFS is like the nuclear cannon of Solaris. It is their Ace of
spaces and it is the reason that the system is arguably the best
choice for high load fileserving. The best way I can describe it
is like...


### Say you had a Burrito...

![I'm a Burrito!](http://fc09.deviantart.net/fs70/f/2013/051/4/8/burrito_cat_para_estetio_by_frikitty-d5vmyzj.png)

...filled with tomatoes, and chilies, and guacamole, and hollandaise sauce,
and just about all of the other great burrito ingredients that you should
so choose to decide to throw at it. The wrap is always big enough.
And also say that this burrito had super powers, that could allow it
to be in two places at once, as if it was in a mirror room at a carnival
or a bad secret agent movie. Lets also suppose that you could take three
bites of the burrito at once! Getting three times the juicy innards every
mouth globbering go around. This burrito also shares itself with your friends
and family, and emails you when it gets sick. The burrito is also very
intelligent, and can even replace stales beans with magical hot spare beans
that await their turn to become a part of this magical experience.

### Say What?

Okay sure, I knew that analogy was kind of a stretch, and most likely
was a sad attempt to describe this incredible technology all wrapped (hehe)
into one golden, warm, marriage killing toilet destroyer.

### Let's try this again...

Go with me on this one. Say you wanted to create the worlds greatest
fileserver. You would most certainly need a few things to ensure
your supremacy.

* Redundancy, either by [Mirroring][mirroring] providing [Parity][Parity]
* Speed, most likely from [Striping][Striping]
* Backups/snapshots
* All sorts of cool features (not limited to)
    * [NFS][NFS]
    * [Samba][Samba]
    * [Access Control][AccessControl]
    * [Disk Quota][DiskQuota]
    * [Hot Spares][HotSpares]
    * [Etc][ZFSProperties]


### Are we there yet?

*NO* and if you ask me one more gosh darn time I'm going to turn this paper
around and teach you how to print double sided text files with `lpr`...

...Let's just continue.

The Dichotomy
-------------

![Anther Great Duo](http://fc03.deviantart.net/fs70/i/2013/131/8/9/batman_and_robin_by_cute_aholic-d64uxn1.jpg)

There are two integral parts to this magical experience. You need to create the
container for the ZFS filesystem. For this we will use a command called `zpool`.
Secondly, will will use a command called `zfs` to make sub-systems within that
container.

### Just nod you heads for right now, I'll go into it

Zpool is first up. What `zpool` will do is take the ingredients of our burrito,
err... it will take the disks we want to make availible and wrap them all up into
one nice manageable system. Now, we can do this in any number of ways. We aren't
exactly limited to just burritos here. We can make tacos, chimichangas, tostadas,
enchuritos, XXL Grilled Stuffed burritos(TM), and the faithful homemade, burrito.
Saying that again in ZFS terms, we could wrap our disks up in mirrors, stripes,
striped mirrors, mirrored stripes, stripes with parity, mirrored stripes with
multiple parity drives with extra hotspares, the combinations are nearly endless.
And like the burrito each different style of disk folding serves its own unique
purpose.

### Let's Create one already!

okay, okay, hold your horses there cow{boy,girl}, I'm just having a little fun.
When using `zpool` you have to understand how it takes its arguments. Thankfully
its pretty straight forward and consistent in its style. Here is an example:

`bunny:~# zpool create mpool mirror c9t0d0 c9t4d0 c12t0d0`

Alright, we have a couple things going on here. Let's get this over with.

* `bunny:~#` is my shell prompt, its at the begining of all of my commands
* `zpool` is the name of the command, (if you didn't get this part, quietly leave the room)
* `create` is the action we want to take, and in this case, will create a pool
* `mpool` is the name of the pool we are referring to, in case of create, this better be new
* `mirror` is the type if pool that we are aiming to create, in this case, mirror the disks
* `c9t0d0 c9t4d0 c12t0d0` are the names of the disks that we want to include into our pool

After executing the command will should see no output, which is a great thing. It means
that the command executed successfully and now we will have a newly created filesystem 
that will live, by default in the root of the whole \*nix filesystem. We can see this
by listing the contents of root.

```
bunny:~# ls /
bin       cat       dev       etc       home      lib       mnt       net
opt       platform  root      sbin      system    tmp       usr       volumes
boot      cdrom     devices   export    kernel    media     mpool     nfs4
pkgs      proc      rpool     stash     tftpboot  u         var       www
```
Before I go on much further, it is also very worth mentioning that there is a very
handy command to check the status of a pool. `zpool status <PoolName>`

```
bunny:~# zpool status mpool
  pool: mpool
 state: ONLINE
  scan: none requested
config:

   NAME         STATE     READ WRITE CKSUM
   mpool        ONLINE       0     0     0
     mirror-0   ONLINE       0     0     0
       c9t0d0   ONLINE       0     0     0
       c9t4d0   ONLINE       0     0     0
       c12t0d0  ONLINE       0     0     0

   errors: No known data errors
```
Which tells us about the pool, notably that it is in fact `ONLINE` and that the
three disks we added to the pool are in fact in a `mirror-0` RAID configuration.

### Proceed to pat yourself on the back

And there you have it. You made a zpool. Good job. I can see that a {guy,girl}
like you is definitely going places. Please take this time to catch your breath,
eat a snickers, and/or call your mom, because you {sir,madam} have earned it.

### Okay, sit back down, shut up, and let's move on

Now just like my father once said:

`INSERT_NAME... I brought you into this world, and I can sure as S*** take you out`

![And he meant it](http://www.buzzreactor.com/sites/default/files/imagecache/picture/images/articles/clint_eastwood.jpg)

and with those words of wisdom, lets take out our pool. This is done with a handy
command called `zpool destroy <PoolName>`. Lettuce try this shall we, by taking out
the pool we so painstakenly worked our butt off to nurture and to hold and to take
to those darn ukelele lessons...

`bunny:~# zpool destroy mpool`

... wait that was it? Our pool..you mean to tell me it just up and vanished just like
that? Yes. It did. Remember young padawan, this is \*nix, which means no news is good
news.

```
bunny:~# zpool status mpool
cannot open 'mpool': no such pool
```

see? that sucker does not even exist for a bit, and now we are free to re use its
disks to create even more pools. Hopefully some more pools that will work right,
appretiate the hard work we do and play a real instrument like the oboe...

...by the way, another handy command here is `zpool list`. This handy piece of
wisdom will tell us about all the current pools in operation, plus some bonus
information like, how big it is, how mush is in use, how much is free, its health
and some other stuff i haven't read about yet.

```
bunny:~# zpool list
NAME   SIZE  ALLOC  FREE  CAP  DEDUP  HEALTH  ALTROOT
rpool  464G  15.6G  448G   3%  1.00x  ONLINE  -
```

Pretty cool huh?
)
### LEVEL UP!

![Get some!](https://lh3.ggpht.com/-l7K-8C5VDfQ/T9bfQLwQCGI/AAAAAAAAAt4/8NunUrza5Xk/s1600/levelup-440x300.jpg)

Woh! Nice, we just leveled up here. We made a zpool and even destroyed it and most
importantly, issued a few zpool commands, thus arranging our neurons to better understand
the steps that are about to come. You are no longer inner tubing on the bunny slopes my friend.
You are about to be skiing on you own (with training wheels and an ambulance on call of
course)


[Mirroring]: http://en.wikipedia.org/wiki/Mirroring_disks
[Parity]: http://en.wikipedia.org/wiki/Parity_drive
[Striping]: http://en.wikipedia.org/wiki/Data_striping
[NFS]: http://en.wikipedia.org/wiki/Network_File_System
[Samba]: http://en.wikipedia.org/wiki/Samba
[AccessControl]: http://en.wikipedia.org/wiki/Access_control_list
[DiskQuota]: http://en.wikipedia.org/wiki/Disk_quota
[HotSpares]: http://en.wikipedia.org/wiki/Hot_spare
[ZFSProperties]: http://docs.oracle.com/cd/E19253-01/819-5461/gazss/index.html


