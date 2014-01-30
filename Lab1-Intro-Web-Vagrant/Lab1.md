Web Services and Databases
================================= 
Install apache
----------------
 
     sudo apt-get install apache2
 
Result:
- service running
    - Look at 'It Works' page
    - Now look at the source in /var/www
    - start/restart/stop service
- www-data user & group created

First look at apache conf
----
### /etc/apache2/apache2.conf
- Set the apache user & group
    - take a look at /etc/apache2/envvars to show where these are defined
- Set location of error log
- Set log levels and examine LogFormat lines
- Set the port it listens on in ports.conf
- See directory perms for /, /usr/share, /var/www, etc.
- AccessFileName &.htaccess files?
- IncludeOptional tells where to look for extra conf files, virtual hosts
    - We'll get to vhosts later
    - Go look in mods_available and mods_enabled - notice the symlinks
- ServerName

Install PHP
---

    sudo apt-get install php5 libapache2-mod-php5

(Say something about cgi vs apache module here)

    sudo a2enmod php5
    sudo service apache2 restart

- Add a php file in web root,`php_info()`, maybe something weird too like `date_sunrise()`. Include an error-generating thing of some sort
- Check out php.ini
    - Set error reporting, error log
- Look at the page again, see difference in error stuff, look at log
- Mention that userdir is also a mod and is easy to do
