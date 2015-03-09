# Packer templates

A subset of [Packer](http://www.packer.io/) templates from the [Bento](https://github.com/opscode/bento) project, customised to remove all but essential packages and use the English - Great Britain locale.

Artefacts produced from these templates are made available publicly as Vagrant base boxes and OVA files.

* Artefacts created by these templates **SHOULD NOT** be used for production
* Artefacts created by these templates **SHOULD NOT** be accessible on the public internet

## Vagrant base boxes

Base boxes are available publicly through the *Antarctica* organisation on [Atlas](https://atlas.hashicorp.com/antarctica), the default source of discovery for Vagrant.

* [`antarctica/trusty`](https://atlas.hashicorp.com/antarctica/boxes/trusty)
    * Ubuntu Server 14.04.2 LTS (amd64) - For *VirtualBox* and *VMware Desktop*

To use one of these base boxes simply list its name in a `Vagrantfile` or follow the instructions on [Vagrant cloud](https://vagrantcloud.com/) to add directly to Vagrant.

### Old base boxes

Older base box versions/releases are deprecated, non-supported and **SHOULD NOT** be used.

Contact [Felix Fennell](mailto:felnne@bas.ac.uk) if you need access to these older boxes.

## OVA files

[OVA files](http://en.wikipedia.org/wiki/Open_Virtualization_Format) [1] are produced as part of the packer build process and retained for more generic purposes, however they are still configured for use with Vagrant (i.e. they contain a vagrant user).

These artefacts are freely available by request, contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

[1] An OVA produces a single file at a smaller file size than a OVF package, making it preferable for distribution.

## Build environment

The following software versions were used to produce the latest released artefacts:

* VirtualBox: version `4.3.24` with version `4.3.24` of the VirtualBox Guest Additions
* VMware: version `7.1.1` (and bundled VMware Tools version)
* Packer: version `0.7.5`

The host machine runs:

* Mac OS X: version `10.9.5`

## Requirements

To create new artefacts from these templates you will need the following software installed locally:

* Mac OS X or Linux
* [Packer](http://www.packer.io/docs/installation.html) `brew cask install packer` [1]
* [VirtualBox](http://www.virtualbox.org) `brew cask install virtualbox` [1]
* [VMware Fusion](http://www.vmware.com/products/fusion) or [VMware Workstation](http://www.vmware.com/products/workstation) `brew cask install vmware-fusion` [1]
* [Ovftool](https://www.vmware.com/support/developer/ovf/) [2]

If testing Vagrant base boxes you will also need:

* [Vagrant](http://www.vagrantup.com) `brew cask install vagrant` [1]
* [Vagrant VMware plugin](www.vagrantup.com/vmware) `vagrant plugin install vagrant-vmware-fusion` [3]

[1] `brew cask` is a binary package manager for Mac OS X, you may need to find these applications yourself.

[2] On a Mac you will probably need to add this to your path i.e. `PATH="/Applications/VMware OVF Tool:$PATH"`

[3] If testing Vagrant base boxes on Linux install `vagrant-vmware-workstation` instead.

## Setup

```shell
$ git clone ssh://git@stash.ceh.ac.uk:7999/baspack/packer-templates.git
$ cd packer-templates
```

## Usage

```shell
$ cd /templates
$ packer build [template]
```

Where: `[template]` is the name of a template in `/templates`.

E.g.

```shell
$ packer build ubuntu-14.04-amd64.json
```

Note: You can tell Packer to use a single builder using the `-only` option.

E.g.

```shell
$ packer build -only=vmware-iso ubuntu-14.04-amd64.json
```

Once built two types artefacts will be created in the `output` directory:

* Vagrant base boxes in `output/base-boxes/boxes`
* VMs in `output/vms` [1] 

Note: The contents of `/output` **MUST NOT** be checked into source control.

[1] As an `.ova` file for VirtualBox or `vmx` package for VMware

## Release/Deployment 

### Base boxes

Base boxes are stored in a S3 bucket, please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

Upload boxes to:

```
packages.calcifer.co/vagrant/baseboxes/[distro]/[version]/[architecture]/[box_version]/
```

E.g.

```
packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/1.0.0/
```

Note: Make sure to make all `.box` files world readable.

#### Atlas

For discovery base boxes are available publicly through the *Antarctica* organisation on [Atlas](https://atlas.hashicorp.com/antarctica), the default source of discovery for Vagrant. Please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

Create a new box/version as needed and enter a relevant description. When adding boxes use the self-hosted option and enter the URL of the `.box` file from S3.

#### Base box meta-data file

A meta-data JSON file is used to record details of the location of each version of a base box. These meta-data files are not strictly required but is recommended for forwards compatibility.

Add a relevant entry to the relevant meta-data file in `output/base-boxes/meta-files`.

You will need to calculate an SHA1 hash of each `.box` file listed in the new version [1].

Upload this file to S3 (see *base boxes* file sub-section for details) to the following location:

```
packages.calcifer.co/vagrant/baseboxes/[distro]/[version]/[architecture]/
```

E.g.

```
packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/
```

Note: Make sure to make all meta-data files world readable.

[1] on Mac OS X you can use `$ openssl sha1 <file>`.

### OVA files

As each builder creates VMs slightly differently, the steps to create an OVA file also differ.

OVA files are stored in a S3 bucket for public access, please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

Upload OVA files to:

```
packages.calcifer.co/ovas/[distro]/[version]/[architecture]/[box_version]/
```

E.g.

```
packages.calcifer.co/ovas/ubuntu/14.04/amd64/1.0.0/
```

Note: Make sure to make all `.ova` files world readable.

#### VirtualBox (`virtualbox-iso`)

VirtualBox produces an OVA file natively, therefore no extra work is needed.

#### VMware (`vmware-iso`)

The `ovftool` can convert the VMX packages into OVA files:

```shell
$ ovftool [.vmx] [.ova]
```

Where: `[.vmx]` is the path to the `.vmx` file and `[.ova>]` is the path to the `.ova` file.

E.g.

```shell
$ ovftool output/vms/ubuntu-14.04-amd64-vmware-iso/vmware.vmx output/vms/ubuntu-14.04-amd64-vmware-iso/vmware.ova
```

## Acknowledgements

Other than using the English Great Britain locale and an altered directory structure, these templates are the same as those found in the [Bento](https://github.com/opscode/bento) project from Chef. 

Therefore 97% of any credit for this project should go to Bento. See their original `NOTICE.md` further licensing information.

The authors of this project are incredibly grateful for their work.

## Contributing

This project welcomes contributions, see `CONTRIBUTING` for our general policy.

## Developing

### Committing changes

The [Git flow](sian.com/git/tutorials/comparing-workflows/gitflow-workflow) workflow is used to manage development of this package.

Discrete changes should be made within feature branches, created from and merged back into develop (where small one-line changes may be made directly).

When ready to release a set of features/changes create a release branch from develop, update documentation as required and merge into master with a tagged, semantic version (e.g. v1.2.3).

After releases the master branch should be merged with develop to restart the process. High impact bugs can be addressed in hotfix branches, created from and merged into master directly (and then into develop).

### Issue tracking

Issues, bugs, improvements, questions, suggestions and other tasks related to this package are managed through the BAS Web & Applications Team Jira project ([BASWEB](https://jira.ceh.ac.uk/browse/BASWEB)).

### License

Copyright 2015 NERC BAS. Licensed under the Apache License for compatibility with Bento, see `LICENSE` for details.
