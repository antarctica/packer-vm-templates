# Packer experiments

Uses [packer](http://www.packer.io/) to create a [vagrant](http://www.vagrantup.com) base box for use as VMs in projects.

Note: Packer templates are OS version specific, currently this experiment covers *Ubuntu 12.04* only.  
Note: Vagrant base boxes are provider specific, currently this experiment covers *VirtualBox* only.

## Overview

Vagrant base boxes require the user to create a VM, install the OS, guest additions (in the case of VirtualBox) and user accounts. This VM is then packaged into a *box*, which is used as a template to stamp out VMs wherever that base is used in a *vagrantfile*.

Packer automates this process by creating a VM, downloading and installing the OS and guest additions (in the case of VirtualBox) and setting user access etc. automatically and non-interactively.

### Rational 

For a single OS and Vagrant provider this may seem overkill (as base boxes don't change that often) but if this changes and multiple OSs (e.g. debian, centos) and providers (e.g. VMWare, AWS) are supported this quickly becomes unmanageable.

Packer does not reduce complexity but it does prevent users having to do everything manually.

## Getting started

### 1 Install Packer

#### Mac OS X (with homebrew installed):

    $ brew tap homebrew/binary
    $ brew install packer
    
#### Other platforms:

See [packer documentation](http://www.packer.io/docs/installation.html).

### 2 Clone repo

    $ git clone git@bitbucket.org:antarctica/packer-experiments.git

### 3 Build base box

    $ packer build ubuntu-12-4-64-template.json
    
Packer will download the OS and VirtualBox guest additions ISOs then create a VirtualBox VM and non-interactively install the OS. Packer will then execute shell commands to install VirtualBox guest additions and enable passwordless sudo.

The configured VM will be shutdown and exported to a Vagrant box, the VM will be destroyed. Leaving just the `.box` file.

This will take 5-10 minutes or longer if ISOs aren't cached, progress can be seen in the VirtualBox VM and from the Packer command line.

### 4 Update vagrant box metadata

Vagrant boxes use a meta-data file to store the name, version and supported providers of each box. A URI to the box and a checksum are also stored. After creating the boxes you will need to ensure these values are correct, simply update the existing values.

Note: On Mac OS X use `$ openssl sha1 <file>` to calculate a SHA1 hash.

### 5 Test base box

#### Add the build box to Vagrant:

    $ vagrant box add ubuntu-12-4-basebox-vritualbox.json

Now create a new VM:

    $ vagrant init felnne/ubuntu-12-4-64
    $ vagrant up

Check no errors are reported and test connecting to the VM using `$ vagrant ssh` and confirming shared folders work correctly.

To remove the test VM:

    $ vagrant halt
    $ vagrant destroy
    $ rm Vagrantfile
    $ rm -rf .vagrant
    
To remove the base box from vagrant (optional):

    $ vagrant box remove felnne/ubuntu-12-4-64
    
### 6 Publish base box

Note: This process has not been formalised yet, therefore it is probably best not to complete this step.