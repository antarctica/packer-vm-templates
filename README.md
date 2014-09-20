# Packer experiments

Uses [packer](http://www.packer.io/) to create a [vagrant](http://www.vagrantup.com) base box for use as VMs in projects.

Note: The structure and contents of this repository will probably change considerably during this testing phase.

## Conventions

In this README:

* values such as `<foo>` are variables and should be substituted for some real value
* directories are absolute to the project root / checkout location
* commands are listed in the `this` style, e.g. `$ packer build`
* important information is given in **bold**

## Overview

Packer is a tool for stating an operating image or ISO, configuring it and outputting the resulting virtual machine in a variety of formats for a variety of formats.

Packer provides conveniences such as integration with ansible and vagrant for automating the configuration and export format of VMs respectively to create vagrant base boxes for use in projects.

For example a packer template can:

* create a VM using a builder (such as VirtualBox)
* download an OS (such as Ubuntu 12.04) and the builder's guest/host integration software (such as the VirtualBox guest additions)
* install these using a installation pre-seeding file and a configuration tool (such as shell scripts and ansible)
* package this VM for use with a provider (such as Vagrant)

All of these steps are performed automatically and are easy to visualise, change and version.

* Packer templates are OS version and provider specific, [see here for a list of supported boxes](https://bitbucket.org/antarctica/packer-experiments/wiki/supported-boxes).
* VMs based on boxes created by this experiment are **not suitable for production**
* VMs based on boxes created by this experiment are **not not safe to be accessible on the public internet**

Note: Whilst this experiment focuses on creating Vagrant BaseBoxes, Packer itself can be used for a wide range of VM provisioning related tasks.


### Rational 

Packer provides a framework that supporting multiple OS versions, distributions and Packer builders and providers more standardised by providing a larger of abstraction and a structured configuration format.

This means configuration steps can be shared between different OS's, builders and providers whether they are written by BAS, other NERC centres or external entities. By the same token we are able to share our configurations in a way that may be directly useful to others.

Packer does not reduce the complexity of creating base OS images but it does automate way many of the differences between builders (VirtualBox, VMware) and providers (Vagrant, AWS) to the point that supporting new options becomes trivial, if indeed someone has not already do so in a form we can use ourselves.

### Packer

Please refer to the [packer documentation](http://www.packer.io/docs) for an introduction to what packer is and its terminology.

### Vagrant

Please refer to the [ansible experiments]() project's README for how Vagrant is used within BAS or the [vagrant documentation](http://docs.vagrantup.com) for an introduction to what vagrant is and its terminology.

### Requirements

On your local machine:

* [VirtualBox](http://www.virtualbox.org)[1] + [Vagrant](http://www.vagrantup.com)[2] installed
* A Mac OS X or Linux operating system. Windows is not currently supported.

[1] The virtual box builder is the only builder currently supported, others may be added soon
[2] The vagrant box provider is the only provider currently supported, others may be added soon

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

    $ packer build packer_templates/ubuntu-14.04-64-basebox.packer.json
    
1. Packer will download the OS and VirtualBox guest additions ISOs checking their signatures.
2. A VirtualBox VM will be created and the OS installed non-interactively.
3. Packer will run some shell scripts to update system packages, set sudo access and install ansible and its dependencies
4. Packer will run an ansible playbook which will configure the VM according to vagrants expectations and install the VirtualBox guest additions
5. Packer will run more shell scripts to remove ansible and its dependencies and clean up software packages, log files and command histories
6. Packer will export the VM to a vagrant box file, the original VM will be destroyed automatically.

This process takes 5-10 minutes or longer if ISOs aren't cached, progress can be seen in the VirtualBox VM during OS installation, then the command line when the VM reboots.

Note: If you review the list of provisioning steps you will see the 'upgrade_packages' script is called after rebooting to complete the earlier call of the same script. This is intentional and isn't actually carried out by packer (it seems to skip whatever the next script call is after rebooting).

### 4 Update vagrant box meta-data

Vagrant uses a meta-data file to store the name, version, supported providers, location and checksum of a box. Meta-data files can reference multiple `.box` files for each vagrant provider it supports (e.g. VirtualBox, VMware).

You will need to edit this file to ensure the location URL, checksums and other details are correct:

    $ nano vagrant_baseboxes/ubuntu-14.04-64-basebox-virtualbox.json

Note: On Mac OS X use `$ openssl sha1 <file>` to calculate a SHA1 hash.

### 5 Test base box

#### Add the build box to Vagrant:

    $ vagrant box add vagrant_baseboxes/ubuntu-14.04-64-basebox.json

Create a new VM:

    $ vagrant init bas/ubuntu-14.04-64
    $ vagrant up

Check no errors are reported and test connecting to the VM using `$ vagrant ssh` and confirming shared folders work correctly.

Remove the test VM:

    $ vagrant halt
    $ vagrant destroy
    $ rm Vagrantfile
    $ rm -rf .vagrant
    
Remove the base box from vagrant (optional):

    $ vagrant box remove bas/ubuntu-14.04-64

Remove generated box (optional):

    $ rm vagrant_baseboxes/ubuntu-14.04-64-basebox-virtualbox.box
    
### 6 Publish base box

Note: This process has not been formalised yet, therefore it is probably best not to complete this step.

To share boxes between users [vagrant cloud](https://vagrantcloud.com) is used. This hosts meta-data about boxes, providers, versions and URIs to the packer generated boxes. Currently these boxes are stored on amazon S3 but this can be easily changed.

Boxes currently belong to `antarctica` such as, `antarctica/ubuntu-14.04-64`.

As a backup/alternative/most-likely-the-sort-of-thing-we'll-use-just-hosted-somewhere-else boxes are stored in an Amazon S3 bucket (packages.calcifer.co) in the `vagrant/baseboxes` directory. See the existing structure for where to put boxes and meta-data files.

Note: If you're doing this make sure the meta-data file (.json) has a content-type header of **`application/json`** otherwise vagrant thinks its a box (rather than meta-data about a box). Not sure who I blame for this, probably Amazon.

### 7 Use base box

Note: This process has not been formalised yet, therefore it is probably best not to complete this step.

To use a box in a project generate a vagrantfile such as `$ vagrant init antarctica/ubuntu-14.04-64`.

## Base box names

Use the following standard for naming a base box

### Packer template (in `/packer_templates`)

#### [Filename]

`<OS>-<version>-<architecture>-basebox.packer.json`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-12.04-64-basebox.packer.json`

#### distro_version

`<OS>-<version>-<architecture>`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-12.04-64`

### Preseed file (in `/preseed`) - if applicable

`<OS>-<version>-<architecture>-basebox.preseed.cfg`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-12.04-64-basebox.preseed.cfg`

### Provisioning playbook (in `/provisioning_playbooks`)

`<OS>-<version>-<architecture>-basebox.<builder>.yml`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-12.04-64-basebox.virtualbox.yml`

### Vagrant box meta-data (in `vagrant_baseboxes`)

#### [Filename]

`<OS>-<version>-<architecture>-basebox.json`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-12.04-64-basebox.json`

#### Name

`<you>/<OS>-<version>-<architecture>`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`felnne/ubuntu-12.04-64`
