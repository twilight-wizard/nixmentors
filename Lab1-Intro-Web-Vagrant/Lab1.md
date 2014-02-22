Webs
===

⁑ indicates a task to accomplish

⁂ indicates an advanced task that can augment or replace a basic task

code snippets will not be given to advanced students, and maybe not to beginners either

Apache
---
### Setting up the service
⁑ Install apache:

    sudo apt-get install apache2

⁑ Visit http://localhost:8080, and examine ongoing HTTP requests with the browser's inspector.

Either:
- Inspector (Firefox) - Ctrl-Shift-C or right click and select 'Inspect Element'
- Web Inspector (Chrome) - Ctrl-Shift-I or right click and select 'Inspect Element'
    
Select the Network tab in either browser.

Refresh the page
- Ctrl-Shift-R in Firefox, or
- Shift-F5 in Chrome

⁑ Take a look at your web root directory. What's in there? Who owns the files?
    
    cd /var/www/
    
What happens if you rename index.html? What happens if you delete it?

⁑ Put some new content on your server's default page

    vim /var/www/index.html

- Include an image and some text and headers
- Make another page in your web root and link to it from your 
- Extra points for CSS or JavaScript fun.

⁑ Install curl, then use it to get the page source - check out the verbose one too:

    curl http://localhost
    curl http://localhost -v
    
⁂ Communicate with your server using netcat/telnet
___

⁑ How's your server doing?

    sudo service apache2 status

⁑ Start, restart and stop your web server. What do these other actions do?

    sudo service apache2 {start|stop|graceful-stop|restart|reload|force-reload|start-htcacheclean|stop-htcacheclean}

⁑ By default apache will stay on unless you tell it to stop, and it will autostart on boot. Disable apache and ensure it doesn't start back up when you restart your VM:

    sudo update-rc.d apache2 disable

⁑ Now enable it again - I bet you can guess how to do this now

___

### Configuring the server

Look at your apache configuration file

    sudo vim /etc/apache2/apache2.conf

Skim through the file. You can probably guess what a lot of these lines do. Sometimes you'll see a variable like `${APACHE_RUN_USER}`. These are environment variables, which are defined in another file. You can edit them here:

    sudo vim /etc/apache2/envvars

Test out all of these things:

⁑ Change the apache user and group to something else:

Make the new user. This will make a new group for the user as well. What do these options to useradd accomplish? Why would we want to use them?

    sudo useradd -r -s /bin/false rambo

Now change the name of the apache user and group in your envvars file. Restart the service to make the new ownership take effect. 

    sudo service apache2 restart

Apache will complain. It has a lock file that still belongs to the old apache user - we can fix this:

    chown -R rambo:rambo /var/lock/apache2/

Figure out how to fix any other error messages it produces.

(more apache stuff coming soon here)

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
