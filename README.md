# Packer experiments

Using [Packer](http://www.packer.io/) to create a [vagrant](http://www.vagrantup.com) base boxes for use in projects. These experiments are based on a subset of templates from the [Bento](https://github.com/opscode/bento) project, customised to remove all but essential packages and use the English - Great Britain locale.

Note: The structure and contents of this repository will probably change considerably during this testing phase.

## Current Base boxes

The following base boxes are publicly available on [Vagrant cloud](https://vagrantcloud.com/) (which is the preferred method of distribution). Click each release to view the latest build and release notes.

To use one of these base boxes simply list its name in a `Vagrantfile` or follow the instructions on [Vagrant cloud](https://vagrantcloud.com/) to add directly to Vagrant.

### Ubuntu
* [antarctica/trusty](https://vagrantcloud.com/antarctica/boxes/trusty) 14.04 LTS amd64
	* VirtualBox
	* VMware

### Debian
* [antarctica/wheezy](https://vagrantcloud.com/antarctica/boxes/wheezy) 7.6 amd64
	* VirtualBox
	* VMware

### CentOS
* [antarctica/cent-6](https://vagrantcloud.com/antarctica/boxes/cent-6) 6.5 x86-64
	* VirtualBox
	* VMware

* [antarctica/cent-7](https://vagrantcloud.com/antarctica/boxes/cent-7) 7.0 x86-64
	* VirtualBox
	* VMware

**Note**:

* VirtualBox base boxes use version `4.3.12`  and include VirtualBox Guest Additions (version: `4.3.12`).
* VMware base boxes use VMware Fusion version `7.0.0` and include VMware Tools.
* All base boxes are built using Packer version `0.7.1` on Mac OS X `10.9.4`.

### Old Base boxes

Older base box versions/releases are deprecated and should not be used. See [here](https://bitbucket.org/antarctica/packer-experiments/wiki/artefacts) for a list of old boxes and locations if desperately needed.

Note: Due to the un-advertised nature of base boxes prior to `1.0.0`, older boxes (i.e. `< 1.0.0`) will likely be removed permanently.

## Conventions

In this README:

* values such as `<foo>` are variables and should be substituted for some real value
* directories are absolute to the project root / checkout location
* commands are listed in the `this` style, e.g. `$ packer build`
* important information is given in **bold**

## Overview

Packer is a tool for taking an operating image (usually in the form of an ISO), installing it as a new VM, performing customisations (e.g. installing base packages) before packaging the resulting VM for use as a starting point with tools such as Vagrant.

Packer provides a framework for performing automated installations of operating systems a *template* which uses a variety of *builders* (such as VirtualBox), *provisioners* (to configure the VM) and *post-processors* for exporting the built VM as an *artefact* (such as a Vagrant base box). A single template may create multiple artefacts using multiple builders for example in parallel.

* We focus on creating Vagrant base boxes (rather than AMIs for AWS or Images for Digital Ocean for example)
* Artefacts are designed to be as minimal as possible, favouring provisioning of software packages and services to be performed by each project (for example a base box should not include ruby pre-installed)
* Wherever possible we follow relevant best practice (i.e. Packer and Vagrant) and wherever possible artefacts should be usable outside of BAS (i.e. use the Vagrant insecure private key rather than a BAS specific key)
* Artefacts created by this experiment are **not suitable for production**
* Artefacts created by this experiment are **not not safe to be accessible on the public internet**

### Packer

Please refer to the [Packer documentation](http://www.packer.io/docs) for an introduction to what Packer is and its terminology.

### Vagrant

Please refer to the [ansible experiments](https://bitbucket.org/antarctica/ansible-experiments) project's README for how Vagrant is used within BAS or the [Vagrant documentation](http://docs.vagrantup.com) for an introduction to what Vagrant is and its terminology.

## License and authors

These packer templates, provisioning and pre-seeding files are based on those from the [Bento](https://github.com/opscode/bento) project from Chef. They are all largely unchanged except for some light refactoring and using the English Great Britain locale.

Therefore 97% of the credit for this project should go to Bento. See NOTICE.md for further licensing information.

As with Bento this project is licensed under the Apache Licence:

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
        
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## Bugs and issues

Until a Jira project can be created please send all bug reports and questions to: [felnne@bas.ac.uk](mailto:felnne@bas.ac.uk).

## Building a box

### Requirements

To build a packer template you will need Packer and any builders/provisioners the template calls. In this project we support two builders, VirtualBox and VMware, which you will need installed, provisioning is performed using shell scripts only.

It is assumed you are using Mac OS X or Linux, install the following:

* [Packer](http://www.packer.io/docs/installation.html)
* [VirtualBox](http://www.virtualbox.org)
* [VMware Fusion](http://www.vmware.com/products/fusion) or [VMware Workstation](http://www.vmware.com/products/workstation)

For testing Vagrant base boxes:

* [Vagrant](http://www.vagrantup.com)
* The [Vagrant VMware plugin](www.vagrantup.com/vmware) if testing VMware based base boxes

### Clone repo

    $ git clone git@bitbucket.org:antarctica/packer-experiments.git

### Run build

    $ packer build <template>

Where: `<template>` is the name of a template in `/templates`.

E.g.

    $ packer build templates/ubuntu-14.04-amd64.json

Packer will begging by downloading installation media (ISO) if not already cached, then boot a new VM and install the OS. After rebooting SSH will be used to configure the OS before shutting down the Vm and exporting it as a Vagrant box. This process is non-interactive and takes between 10-15 minutes where install media is cached.

After  build completes you will see an output like:

    ==> Builds finished. The artifacts of successful builds are:
    --> virtualbox-iso: 'virtualbox' provider box: ../base-boxes/boxes/ubuntu-14.04-amd64/virtualbox.box
    --> vmware-iso: 'vmware' provider box: ../base-boxes/boxes/ubuntu-14.04-amd64/vmware.iso

## Releasing a box

### Box file

Build boxes are stored in an S3 bucket for public access. Please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access details.

Upload boxes to the following location:

    packages.calcifer.co/vagrant/baseboxes/<distro>/<version>/<architecture>/<box_version>/

E.g.

    packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/1.0.0/

Note: Make sure to make all `.box` files world readable.

### Meta-data file

A meta-data JSON file is used to record details of the location of each version of a base box. These meta-data files are not straightly required as [Vagrant Cloud](https://vagrantcloud.com/) performs the same function for us, but these files are versioned and can be used where [Vagrant Cloud](https://vagrantcloud.com/) may be unsuitable.

Add a relevant entry to the relevant meta-data file in `/base-boxes/meta-files`. You will need to calculate an SHA1 hash of each `.box` file listed in the new version, on Mac OS X you can use `$ openssl sha1 <file>`.

Upload this file to S3 (see box file sub-section for details) to the following location:

    packages.calcifer.co/vagrant/baseboxes/<distro>/<version>/<architecture>/

E.g.

    packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/

Note: Make sure to make all meta-data files world readable.

### Project wiki

Details of all base boxes, including meta-data file links, raw `.box` links and SHA1 hashes are listed in the [project wiki](https://bitbucket.org/antarctica/packer-experiments/wiki/artefacts). Update this page as needed.

### Vagrant cloud

Base boxes are listed under the *antarctica* organisation on [Vagrant cloud](https://vagrantcloud.com/antarctica) for public access. Please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access details.

Create a new box/version as needed and enter a relevant description. When adding boxes use the self-hosted option and enter the URL of the `.box` file from S3.