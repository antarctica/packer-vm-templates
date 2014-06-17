# Packer experiments

Uses [packer](http://www.packer.io/) to create a [vagrant](http://www.vagrantup.com) base box for use as VMs in projects.

Note: The structure and contents of this repository will probably change considerably during this testing phase.

## Conventions

In this README:

* values such as `<foo>` are variables and should be substituted for some real value
* directories are relative to the repository root
* commands are listed in `this` style, e.g. `$ vagrant status`

## Overview

Vagrant base boxes require the user to create a VM, install the OS, guest additions (in the case of VirtualBox) and user accounts. This VM is then packaged into a *box*, which is used as a template to stamp out VMs wherever that base is used in a *vagrantfile*.

Packer automates this process by creating a VM, downloading and installing the OS and guest additions (in the case of VirtualBox) and setting user access etc. automatically and non-interactively.

* Packer templates are OS version and provider specific, [see here for a list of supported boxes](https://bitbucket.org/antarctica/packer-experiments/wiki/supported-boxes)
* VMs based on boxes created by this experiment are **not suitable for production**
* VMs based on boxes created by this experiment are **not not safe to be accessible on the public internet**

### Rational 

For a single OS and Vagrant provider this may seem overkill (as base boxes don't change that often) but if this changes and multiple OSs (e.g. debian, centos) and providers (e.g. VMWare, AWS) are supported this quickly becomes unmanageable.

Packer does not reduce complexity but it does prevent users having to do everything manually and makes supporting new upgrades, operating systems and providers much quicker and standardised.

### Packer

Please refer to the [packer documentation](http://www.packer.io/docs) for an introduction to what packer is and its terminology.

These experiments use the latest version and follow published best practice wherever possible.

### Requirements

On your local machine:

* [VirtualBox](http://www.virtualbox.org)[1] + [Vagrant](http://www.vagrantup.com)[2] installed
* A *Mac/Linux* terminal with a `SSH` client. Windows is currently not supported.

[1] VirtualBox is the only builder currently supported, others may be added soon.  
[2] Vagrant is the only provider currently supported, others may be added soon.

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

    $ packer build packer_templates/ubuntu-12.04-64-basebox.packer.json
    
Packer will download the OS and VirtualBox guest additions ISOs then create a VirtualBox VM and non-interactively install the OS. Packer will then execute shell commands to install VirtualBox guest additions and enable passwordless sudo.

The configured VM will be shutdown and exported to a Vagrant box, the VM will be destroyed. Leaving just the `.box` file inside `vagrant_baseboxes`.

This will take 5-10 minutes per OS/provider or longer if ISOs aren't cached, progress can be seen in the VirtualBox VM and from the Packer command line.

### 4 Update vagrant box metadata

Vagrant boxes use a meta-data file to store the name, version and supported providers of each box. A URI to the box and a checksum are also stored. After creating the boxes you will need to ensure these values are correct, these files are stored in `vagrant_baseboxes`.

Note: On Mac OS X use `$ openssl sha1 <file>` to calculate a SHA1 hash.

### 5 Test base box

#### Add the build box to Vagrant:

    $ vagrant box add vagrant_baseboxes/ubuntu-12.04-64-basebox-virtualbox.json

Create a new VM:

    $ vagrant init felnne/ubuntu-12.04-64
    $ vagrant up

Check no errors are reported and test connecting to the VM using `$ vagrant ssh` and confirming shared folders work correctly.

Remove the test VM:

    $ vagrant halt
    $ vagrant destroy
    $ rm Vagrantfile
    $ rm -rf .vagrant
    
Remove the base box from vagrant (optional):

    $ vagrant box remove felnne/ubuntu-12.04-64

Remove generated box (optional):

    $ rm vagrant_baseboxes/ubuntu-12.04-64-basebox-virtualbox.box
    
### 6 Publish base box

Note: This process has not been formalised yet, therefore it is probably best not to complete this step.

To share boxes between users [vagrant cloud](https://vagrantcloud.com) is used. This hosts meta-data about boxes, providers, versions and URIs to the packer generated boxes. Currently these boxes are stored on amazon S3 but this can be easily changed.

Boxes currently belong to the `antarctica` such as, `antarctica/ubuntu-12.04-64`.

To use a box in a project generate a vagrantfile such as `$ vagrant init antarctica/ubuntu-12.04-64`.