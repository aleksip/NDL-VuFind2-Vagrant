# NDL-VuFind2-Vagrant
Vagrant setup for NDL VuFind2 with 2 separate virtual machines:
- 'ubuntu' (default) - for development, uses working files from the host's filesystem
- 'centos' - a testbed to build a personal test server; SELinux enabled so could maybe even be a rough outline to set-up a production server, who knows

Requirements
------------
- <a href="https://www.virtualbox.org">VirtualBox</a>
- <a href="https://www.vagrantup.com">Vagrant</a>

for ubuntu only:
- <a href="https://github.com/NatLibFi/NDL-VuFind2">NDL-VuFind2</a> (fork it!) cloned to the host computer (with a working configuration - for the minimum, change the config to use the NDL development index URL)

Set-up
------
ubuntu only:

Put the files in a directory parallel to the NDL-VuFind2 working directory e.g. path-to/vufind2 & same-path-to/vagrant_vufind2. If the working directory is other than vufind2, modify the Vagrantfile accordingly.

Use
---
ubuntu:
- 'vagrant up' (this will take a few minutes so enjoy your beverage of choice)
- Point your browser to <a href="http://localhost:8081">http://localhost:8081</a>
- (Blank page or errors: adjust the config(s) & run 'vagrant provision', reload browser page.)

centos:
- 'vagrant up centos'
- 'vagrant ssh centos'
- '/usr/bin/mysql_secure_installation' to add MySQL root password and remove anonymous user & test databases
- manually add a working index URL to the INSTALLATION_PATH/local/config/vufind/config.ini file.
- 'exit'
- <a href="http://localhost:8082">http://localhost:8082</a>
- (Blank page or errors: adjust the config(s), reload browser page.)

Both machines can be running simultaneously provided the host has enough oomph.

Useful commands
---------------
* 'vagrant reload' - reloads the configuration changes made to Vagrantfile
* 'vagrant suspend' - freezes the virtual machine, continue with 'vagrant resume'
* 'vagrant halt' - shuts down the virtual machine, restart with 'vagrant up'
* 'vagrant destroy'  - deletes the virtual machine along with any cached box files etc.
* 'vagrant ssh' - login to the running virtual machine (vagrant:vagrant) e.g. to restart Apache ('sudo service apache2 restart') or to check Apache logs in /var/log/apache2/ ('sudo tail -f /var/log/apache2/error.log', 'sudo tail -f /var/log/apache2/access.log')
* 'vagrant plugin install vagrant-vbguest' - for prolonged use, installs <a href="https://github.com/dotless-de/vagrant-vbguest">vagrant-vbguest</a> plugin to keep the host machines's VirtualBox Guest Additions automatically updated
* ( 'vagrant package --output ubuntu_vufind2.box' if for some reason the virtual machine needs to be packaged as a new base box, roughly 700MB or more. The Vagrantfile needs to be edited to use the created box file. )

When addressing the centos machine, just add ' centos' at the end of each command.

<a href="https://docs.vagrantup.com/v2/cli/index.html">Vagrant documentation</a> for more info.

Known Issues
------------
- Slower than native LAMP/MAMP. You can try adding more v.memory/v.cpus in Vagrantfile.
- Copying the vufind2/local directory inside the virtual machine is a dirty hack to get the virtual machine to access local/cache. Any changes under local/config/ in the host need to be relayed to the virtual machine by running the provisioning with 'vagrant provision' (or building the virtual machine again with 'vagrant destroy' & 'vagrant up'). 
- If running Solr, v.memory needs to be adjusted (2048 should work).
