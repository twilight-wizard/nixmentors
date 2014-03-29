Searching for packages

    yum search git-review

List the files in a package

    rpm -ql git

Show package information

    rpm -qi git
    yum info git

List all installed packages 

    rpm -qa
    yum list installed

List all updates

    yum list updates

What provides a file

   rpm -qf /usr/bin/git
   yum whatprovides '*bin/git'

Listing groups

   yum grouplist
