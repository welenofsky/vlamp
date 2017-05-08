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

### group_vars/all
This is where you put your git private key and ssh repo clone link used for provisioning the virtualbox



## Setting Up Local Environment
1. Create a virtual environment, .env/ in this directory by using virtualenv command
```
virtualenv .env/ --python=python2.7
```

2. Access the virtualenv
```
source .env/bin/activate
```

3. Install the dependency (ansible) with pip
```
pip install -r requirements.txt
```

4. Get Vagrant

```
vagrant up
```
Now you should have a development environment. If you need to manually provision you can use or use ansible as shown below.

```
vagrant provision
```

## Deployment

todo


### TODO

Set root password? Idempotent?
Casper/Cosmo whatever you call it script to seperate deploy from provision etc.
