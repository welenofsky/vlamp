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


