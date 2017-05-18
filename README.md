Using the ansible provisioning script
=================================================

## Required Packages

* python 2.7 / pip
* Vagrant
* ansible
* virtualenv

## Configuration files

### config/
Edit the config files for the respective environment. The files live in config folder. They should be self-explanatory. These files are for currently only contain the DB credentials and variables used for provisioning (like for the home folder name)

1. Setup

To setup just bring the box up with vagrant up. The first time it will take the longest.
```
vagrant up
```
Now you should have a development environment. If you need to manually provision you can use or use ansible as shown below.

```
vagrant provision
```


## How To

### How do I access this box?
It uses DHCP to get an IP from your local network. To view the IP you can SSH into the box using
```
vagrant ssh
```
Then use ifconfig to see what IP you are using for the ETH interface ( note you may have a few ETH interfaces ). Once you get that ip you can access the site by going to that IP in your web browser. I also recommend setting a domain name for this box like vlamp.local.com in your /etc/hosts file

### How to see mail sent from this server?
This server uses mailcatcher. So just go to the IP of the box in your web browser and append the port :1080 to it. For example. vlamp.local.com:1080


### Is SSL Setup?
Yes, a self signed certificate is created when you provision the box. No setup needed.


