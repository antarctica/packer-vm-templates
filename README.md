# Packer experiments

Using [Packer](http://www.packer.io/) to create a [vagrant](http://www.vagrantup.com) base boxes for use in projects.

Note: The structure and contents of this repository will probably change considerably during this testing phase.

## Conventions

In this README:

* values such as `<foo>` are variables and should be substituted for some real value
* directories are absolute to the project root / checkout location
* commands are listed in the `this` style, e.g. `$ packer build`
* important information is given in **bold**

## Overview

Packer is a tool for taking an operating image (usually in the form of an ISO), installing it as a new VM, performing customisations (e.g. installing base packages) before packaging the resulting VM for use as a starting point with tools such as Vagrant.

Packer provides a framework for performing automated installations of operating systems using a variety of builders (such as VirtualBox to produce a VM image), provisioners (used to configure the built VM to install custom packages etc.) and tools for exporting the built VM as an 'image' (such as a Vagrant base box).

An example workflow using Packer might be:

1. Perform an automated installation of an operating system using a *builder* (such as a VirtualBox VM)
2. Configure the operating system with custom settings and packages (such as VM integration tools) using one or more *provisioners*
3. Package the resulting operating system into a variety of *artefacts* (such as a Vagrant base box) using one or more *post provisioners*

These stages collectively make up a packer *template* (a JSON file), a single template may create multiple *artefacts* using multiple *builders* (for example a VM image for VirtualBox and VMware), multiple *provisioners* and multiple *post-processors*.

Within this project:

* We focus on creating Vagrant base boxes (rather than AMIs for AWS or Images for Digital Ocean for example)
* Artefacts are designed to be as minimal as possible, favouring provisioning of software packages and services to be performed by each project (for example a base box should not include ruby pre-installed)
* Wherever possible we follow relevant best practice (i.e. Packer and Vagrant) and wherever possible artefacts should be usable outside of BAS (i.e. use the Vagrant insecure private key rather than a BAS specific key)
* Artefacts created by this experiment are **not suitable for production**
* Artefacts created by this experiment are **not not safe to be accessible on the public internet**

### Supported artefacts

[A list of artefacts produced by this project is available here](https://bitbucket.org/antarctica/packer-experiments/wiki/artefacts)

Note: This page lists all artefacts that have ever been produced by this project, including deprecated/non-supported ones. Please note the guidance listed on the wiki page for which artefact versions are recommended/supported for use in other projects.

This project includes templates for these operating systems:

* Ubuntu 14.04 LTS AMD 64

This project supports the following builders:

* VirtualBox
* VMware desktop (VMware Fusion and VMware Workstation)

This project supports the following post-processors:

* Vagrant base box

### Rational 

Packer provides a framework that supporting multiple OS versions, distributions and Packer builders and providers more standardised by providing a larger of abstraction and a structured configuration format.

This means configuration steps can be shared between different OS's, builders and providers whether they are written by BAS, other NERC centres or external entities. By the same token we are able to share our configurations in a way that may be directly useful to others.

Packer does not reduce the complexity of creating base OS images but it does automate way many of the differences between builders (VirtualBox, VMware) and providers (Vagrant, AWS) to the point that supporting new options becomes trivial, if indeed someone has not already do so in a form we can use ourselves.

### Packer

Please refer to the [Packer documentation](http://www.packer.io/docs) for an introduction to what Packer is and its terminology.

### Vagrant

Please refer to the [ansible experiments](https://bitbucket.org/antarctica/ansible-experiments) project's README for how Vagrant is used within BAS or the [Vagrant documentation](http://docs.vagrantup.com) for an introduction to what Vagrant is and its terminology.

### Requirements

On your local machine:

* A Mac OS X or Linux operating system[1]

For using the VirtualBox builder:

* [VirtualBox](http://www.virtualbox.org)[1]

For using the VMware builder:

* [VMware Fusion](http://www.vmware.com/products/fusion) or [VMware Workstation](http://www.vmware.com/products/workstation)

For testing Vagrant base boxes:

* [Vagrant](http://www.vagrantup.com)
* The [Vagrant VMware plugin](www.vagrantup.com/vmware) if testing VMware based base boxes

[1] Windows is not currently supported.

## Getting started

### 1 Install Packer

#### Mac OS X (with homebrew installed)

    $ brew tap homebrew/binary
    $ brew install packer
    
#### Other platforms

See [Packer documentation](http://www.packer.io/docs/installation.html).

### 2 Clone repo

    $ git clone git@bitbucket.org:antarctica/packer-experiments.git

### 3 Create artefact using template

Templates are stored in `packer_templates`, currently each template focuses on a single OS, for a single builder producing a single artefact (i.e. a one to one relationship between template and artefact) but this may change.

    $ packer build packer_templates/<packer_template>.json

Where: `<packer_template>` is the name of a Packer template.

E.g:

    $ packer build packer_templates/ubuntu-14.04-64-virtualbox-basebox.packer.json

Though generalised the steps below give a good overview of what Packer does:

1. Packer will download or find the OS and VM tools ISOs and check their signatures.
2. A VM will be created and the OS installed non-interactively.
3. Packer will run some provisioners which may be scripts or configuration scripts such as Ansible playbooks to update system packages, set sudo access and install the VM tools and any other required packages.
5. Packer will run some more provisioners to clean up software packages, log files and histories.
6. Packer will export the VM to create an artefact file, the VM will be destroyed automatically.

This process takes 5-10 minutes or longer if ISOs aren't cached, progress can be seen in the VM during OS installation, then the command line after the VM reboots.

Note: If you review the list of provisioning steps you will see the 'upgrade_packages' script is called after rebooting to complete the earlier call of the same script. This is intentional and isn't actually carried out by Packer (it seems to skip whatever the next script call is after rebooting).

### 4 Update vagrant base box meta-data

Vagrant base box artefacts are stored in `vagrant_baseboxes`.

Vagrant uses a meta-data file to store the name, versions and supported providers (equivalent of Packer builders) of one or more boxes. Each box entry lists its location (URL) and checksum of the box.

    $ nano vagrant_baseboxes/<meta-data file>.json

Where: `<meta-data file>` is a Vagrant base box meta-data file.

E.g.

    $ nano vagrant_baseboxes/ubuntu-14.04-64.json

Note: On Mac OS X use `$ openssl sha1 <file>` to calculate a SHA1 hash.

E.g.

    $ openssl sha1 vagrant_baseboxes/ubuntu-14.04-64-virtualbox.box

### 5 Test Vagrant base box (optional)

#### Add box to Vagrant

    $ vagrant box add <meta-data file>.json

Where: `<meta-data file>` is the name of the meta-data file describing the base box you wish to test.

E.g.

    $ vagrant box add vagrant_baseboxes/ubuntu-14.04-64.json

For boxes with multiple providers Vagrant will ask which should be used to determine which base box to download.

Note: Before you can download the base box you will need to ensure it is available at the URL given in the meta-data file.

#### Create a test VM

    $ vagrant init <box>
    $ vagrant up

Where: `<box>` is the name of the Vagrant base box added earlier.

E.g.

    $ vagrant init antarctica/trusty
    $ vagrant up

The most important thing to test (other than the VM successfully booting) is shared folder support. If no errors occur during the initial VM creation, try to reboot the VM (`$ vagrant reload`) and test shared folders remain accessible (this will rule out any kernel changes that will apply only after a restart).

#### Remove the test VM

    $ vagrant halt
    $ vagrant destroy
    $ rm Vagrantfile
    $ rm -rf .vagrant
    
#### Remove box from Vagrant (optional)

    $ vagrant box remove <box>

Where: `<box>` is the name of the Vagrant base box added earlier.

E.g.

    $ vagrant box remove antarctica/trusty

Note: If you need to remove a specific version of a box use the `--box-version` flag.

E.g.

    $ vagrant box remove antarctica/trusty --box-version=0.4.0
    
### 6 Publish base box

Note: This process has not been formalised yet, therefore it is probably best not to complete this step.

To share Vagrant base boxes between users it must be available at a common location (such as a shared web server or AWS S3 bucket), this includes both the meta-data file and `.box` files (however the `.box`) files can be stored at a different location to the meta-data file if needed.

Note: In meta-data files, always use HTTPS URLs to specifying the location of boxes.

Currently boxes and meta-data files are stored in the AWS S3 bucket `packages.calcifer.co` in the `vagrant/baseboxes` directory and accessible to anyone who can guess their location.

Boxes are also listed on the public [Vagrant Cloud](https://vagrantcloud.com) under the [*antarctica*](https://vagrantcloud.com/antarctica) organisation/namespace. This is the preferred location from which to consume our boxes (because its the easiest for users).

When uploading:

* Follow the existing folder structure for `.box` files: `vagrant/baseboxes/<os family>/<os version>/<architecture>/<builder>/<version>/`

* Follow the existing folder structure for meta-data files: `vagrant/baseboxes/<os family>/<os version>/<architecture>/` using a content type of `application/json`

Note: Contact [felnne@bas.ac.uk](mailto:felnne@bas.ac.uk) to access this bucket.

After uploading:

* Update the [list of artefacts](https://bitbucket.org/antarctica/packer-experiments/wiki/artefacts)

* Update the box information on [Vagrant Cloud](https://vagrantcloud.com) to release a new version (with relevant change log information and providers using the self-hosted option).

Note: Contact [felnne@bas.ac.uk](mailto:felnne@bas.ac.uk) to access the [*antarctica*](https://vagrantcloud.com/antarctica) organisation.

### 7 Use base box

#### Add box to Vagrant (optional)

Vagrant will automatically try to find an unknown base box, as our boxes are listed on [Vagrant Cloud](https://vagrantcloud.com), Vagrant will automatically find and download the relevant box automatically.

To install manually using [Vagrant Cloud](https://vagrantcloud.com):

    $ vagrant box add antarctica/<box>

Where: `<box>` refers to a box from the [*antarctica*](https://vagrantcloud.com/antarctica) organisation on [Vagrant Cloud](https://vagrantcloud.com).

E.g.

    $ vagrant box add antarctica/trusty

To install manually using a meta-data.json file:

Note: There is no advantage to doing this and you will loose some features such as automatic version tracking using this method.

    $ vagrant box add <meta-data file>.json

Where: `<meta-data file>` is the name of the meta-data file describing the base box you wish to test.

Note: Always use HTTPS for loading base box meta-data files.

E.g.

    $ vagrant box add https://s3-eu-west-1.amazonaws.com/packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/x64/ubuntu-14.04-64.json

Regardless of which method is used, for boxes with multiple providers Vagrant will ask which should be used, to determine which to download.

#### Create a VM

Vagrant will automatically try to find an unknown base box, as our boxes are listed on [Vagrant Cloud](https://vagrantcloud.com), Vagrant will automatically find and download the relevant box automatically.

    $ vagrant init antarctica/<box>
    $ vagrant up

Where: `<box>` refers to a box from the [*antarctica*](https://vagrantcloud.com/antarctica) organisation on [Vagrant Cloud](https://vagrantcloud.com).

E.g.

    $ vagrant init antarctica/trusty
    $ vagrant up

## Naming conventions

Note: Older versions of templates, configuration files and artefacts may not follow the conventions written here as they pre-date them.

### Packer template `/packer_templates`

#### (Filename)

`<os>-<version>-<architecture>-<builder>-<artefact-type>.packer.json`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64-virtualbox-basebox.packer.json`


#### ssh_username (template variable)

`vagrant`

#### ssh_password (template variable)

`vagrant`

#### hostname (template variable)

`vagrant`

#### distro_version (template variable)

`<os>-<version>-<architecture>`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64`

#### builder_type (template variable)

`<builder_type>`

E.g.

`virtualbox`

#### Output directory

`<os>-<version>-<architecture>-<builder>`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64-virtualbox`

#### Post-processor output

`<artefact-type>/<os>-<version>-<architecture>-<builder>.box`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`vagrant_baseboxes/ubuntu-14.04-64-virtualbox.box`

#### VM name (optional)

`<os>-<version>-<architecture>`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64`

### Preseed file `/preseed` (optional)

`<os>-<version>-<architecture>.preseed.cfg`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64-basebox.preseed.cfg`

### Provisioning playbook `/provisioning_playbooks` (optional)

`<os>-<version>-<architecture>-<builder>-<artefact-type>.yml`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64-virtualbox-basebox.yml`

### Vagrant base box meta-data file `vagrant_baseboxes` (optional)

#### (Filename)

`<os>-<version>-<architecture>.json`

Note: Use lowercase alpha-numeric or `.` characters only.

E.g.

`ubuntu-14.04-64.json`

#### Name

Though this breaks consistency we use friendlier names for referring to base boxes.

E.g. Instead `ubuntu-14.04-64` we use `trusty` as its unlikely two operating systems will use the same code-names for releases and we will typically only support one architecture. Where an update needs to be handled (say 14.1) we would need to re-release the base-boxes anyway we can therefore use the box version to reflect a changed OS version.

We namespace all boxes with `antarctica` for best practice and avoiding clashes.

E.g. `antarctica/trusty`

Note: The name of the box as reported to Vagrant has no relation to the name of the box file (or meta-data file) and should follow their own conventions. Within Vagrant (e.g. `$ vagrant box list`) the friendly name will be shown.

#### Description

Usually the following format is used:

`<os> <version> <architecture> base box`

E.g.

Ubuntu 14.04 LTS 64-bit base box
