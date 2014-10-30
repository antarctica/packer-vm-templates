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

Older base box versions/releases are deprecated and should not be used.

Note: Due to the un-advertised and largely non-working nature, base boxes prior to `1.0.0` will likely be removed permanently.

## Conventions

In this README:

* values such as `<foo>` are variables and should be substituted for some real value
* directories are absolute to the project root / checkout location
* commands are listed in the `this` style, e.g. `$ packer build`
* important information is given in **bold**

## Overview

Packer is a tool for taking an operating image (usually in the form of an ISO), installing it as a new VM, performing customisations (e.g. installing base packages) before packaging the resulting VM for use as a starting point with tools such as Vagrant.

Packer provides a framework for performing automated installations of operating systems a *template* which uses a variety of *builders* (such as VirtualBox), *provisioners* (to configure the VM) and *post-processors* for exporting the built VM as an *artefact* (such as a Vagrant base box). A single template may create multiple artefacts using multiple builders running in parallel.

* We focus on creating Vagrant base boxes (rather than AMIs for AWS or Images for Digital Ocean for example)
* Artefacts are designed to be as minimal as possible, favouring provisioning of software packages and services to be performed by each project (for example a base box should not include ruby pre-installed)
* Wherever possible we follow relevant best practice (i.e. Packer and Vagrant) and wherever possible artefacts should be usable outside of BAS (i.e. use the Vagrant insecure private key rather than a BAS specific key)
* Artefacts created by this experiment are **not suitable for production**
* Artefacts created by this experiment are **not not safe to be accessible on the public internet**

### Packer

Please refer to the [Packer documentation](http://www.packer.io/docs) for an introduction to what Packer is and its terminology.

### Vagrant

Please refer to the [Ansible experiments](https://bitbucket.org/antarctica/ansible-experiments) project's README for how Vagrant is used within BAS or the [Vagrant documentation](http://docs.vagrantup.com) for an introduction to what Vagrant is and its terminology.

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

### NERC Users

Please log issues to the **BASWEB** project in [Jira](https://jira.ceh.ac.uk).

### Non-NERC Users

Please contact: [felnne@bas.ac.uk](mailto:felnne@bas.ac.uk).

## Building using a template

Each Packer template contains the builders that will be used to create one or more VMs (e.g. VirtualBox and VMware), the provisioners that will configure each VM and the post-processors that will export each VM into one or more formats (Vagrant base box, OVA files, VMX packages, etc.).

### Requirements

To build a packer template from this Project you will need Packer plus any builders/provisioners the template uses.

It is assumed you are using Mac OS X or Linux, ensure you have the following installed:

* [Packer](http://www.packer.io/docs/installation.html)
* [VirtualBox](http://www.virtualbox.org)
* [VMware Fusion](http://www.vmware.com/products/fusion) or [VMware Workstation](http://www.vmware.com/products/workstation)
* The `ovftool` command (see [here](https://www.vmware.com/support/developer/ovf/) for installation instructions (on a Mac you will probably need to add this to your path i.e. `PATH="/Applications/VMware OVF Tool:$PATH"`))

For testing Vagrant base boxes:

* [Vagrant](http://www.vagrantup.com)
* The [Vagrant VMware plugin](www.vagrantup.com/vmware) if testing VMware based base boxes

### Clone repo

    $ git clone git@bitbucket.org:antarctica/packer-experiments.git

### Run build

    $ cd /templates
    $ packer build <template>

Where: `<template>` is the name of a template in `/templates`.

E.g.

    $ packer build ubuntu-14.04-amd64.json

Note: You can tell Packer to use a single builder using the `-only` flag.

E.g.

    $ packer build -only=vmware-iso ubuntu-14.04-amd64.json

Packer will begin by downloading installation media (ISO) if not already cached, then boot a new VM and install the OS. After rebooting the VM will be configured using SSH before being shut down and exported as a VM and as a Vagrant base box. This process is non-interactive and takes between 10-15 minutes where install media is already cached.

Once built two artefacts will be created in the `output` directory:

* Vagrant base box in `output/base-boxes/boxes`
* The built VM as either an `.ova` file or `vmx` package in `output/vms`

Note: Neither base boxes or VM outputs should be checked into source control.

## Releasing a build

### Box file

Build boxes are stored in an S3 bucket for public access. Please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access details.

Upload boxes to the following location:

    packages.calcifer.co/vagrant/baseboxes/<distro>/<version>/<architecture>/<box_version>/

E.g.

    packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/1.0.0/

Note: Make sure to make all `.box` files world readable.

### Box meta-data file

A meta-data JSON file is used to record details of the location of each version of a base box. These meta-data files are not strictly required as [Vagrant Cloud](https://vagrantcloud.com/) performs the same function for us, but these files are versioned and can be used where [Vagrant Cloud](https://vagrantcloud.com/) may be unsuitable.

Add a relevant entry to the relevant meta-data file in `output/base-boxes/meta-files`. You will need to calculate an SHA1 hash of each `.box` file listed in the new version, on Mac OS X you can use `$ openssl sha1 <file>`.

Upload this file to S3 (see box file sub-section for details) to the following location:

    packages.calcifer.co/vagrant/baseboxes/<distro>/<version>/<architecture>/

E.g.

    packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/

Note: Make sure to make all meta-data files world readable.

### OVA file

VMs built from these templates can be imported directly using the Open Virtualisation Format, which is supported by all major virtualisation providers such as VMware and VirtualBox. An OVA (Open Virtualisation Archive) as its name suggests is simply an archive of an OVF package.

Since an OVA produces a single file at a smaller file size this is the preferred format for distribution of OVF packages.

As each builder creates VMs slightly differently, the steps to create an OVA file also differ.

#### virtualbox-iso

VirtualBox can produce an OVA file natively and therefore you shouldn't need to do anything.

#### vmware-iso

The `ovftool` is used to convert the built VM into an OVA file.

    $ ovftool <.vmx> <.ova>

Where: `<.vmx>` is the path to the `.vmx` file and `<.ova>` is the path to the `.ova` file.

E.g.

    $ ovftool output/vms/ubuntu-14.04-amd64-vmware-iso/vmware.vmx output/vms/ubuntu-14.04-amd64-vmware-iso/vmware.ova

As with Vagrant boxes, OVA files are stored in an S3 bucket for public access. Please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access details.

Upload OVA files to the following location:

    packages.calcifer.co/ovas/<distro>/<version>/<architecture>/<box_version>/

E.g.

    packages.calcifer.co/ovas/ubuntu/14.04/amd64/1.0.0/

Note: Make sure to make all `.ova` files world readable.

### Vagrant cloud

Base boxes are listed under the *antarctica* organisation on [Vagrant cloud](https://vagrantcloud.com/antarctica) for public access. Please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access details.

Create a new box/version as needed and enter a relevant description. When adding boxes use the self-hosted option and enter the URL of the `.box` file from S3.
