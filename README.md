# Packer templates

A subset of [Packer](http://www.packer.io/) templates from the [Bento](https://github.com/opscode/bento) project, 
customised to remove all but essential packages and use the English - Great Britain locale.

Artefact's produced from these templates are made available publicly as Vagrant base boxes and OVA files.

* Artefact's created by these templates **MAY** be used for production
* Artefact's created by these templates **SHOULD NOT** be accessible on the public internet

## Vagrant base boxes

* [`antarctica/trusty`](https://atlas.hashicorp.com/antarctica/boxes/trusty)
    * Ubuntu Server 14.04.3 LTS (amd64) - For *VirtualBox* and *VMware Desktop*
* [`antarctica/centos7`](https://atlas.hashicorp.com/antarctica/boxes/centos7)
    * CentOS 7.1 (x86_64) - For *VirtualBox* and *VMware Desktop*

Base boxes are available publicly through the *Antarctica* organisation on 
[Atlas](https://atlas.hashicorp.com/antarctica), the default source of discovery for Vagrant.

To use one of these base boxes simply list its name in a `Vagrantfile`, 
or follow the instructions in the [Atlas documentation](https://atlas.hashicorp.com/help/vagrant/boxes/catalog).

### Old base boxes

Older base box versions/releases are deprecated, non-supported and **SHOULD NOT** be used.

Contact [Felix Fennell](mailto:felnne@bas.ac.uk) if you need access to these older boxes.

## OVA files

* Ubuntu Server 14.04.3 LTS (amd64) - For *VirtualBox* and *VMware Desktop*
* CentOS 7.1 (x86_64) - For *VirtualBox* and *VMware Desktop*

[OVA files](http://en.wikipedia.org/wiki/Open_Virtualization_Format) [1] are produced as part of the packer build 
process and retained for more generic purposes. These images are a by-product of creating Vagrant base boxes, 
they therefore are configured with a vagrant user etc.

These artefact's are freely available by request, contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

[1] An OVA produces a single file at a smaller file size than a OVF package, making it preferable for distribution.

## DigitalOcean base images

* template-ubuntu-14.04-amd64
    * Image ID: `13126041`
    * Ubuntu Server 14.04.3 LTS (amd64)
    * Available features:
        * Backups: *false*
        * Private networking: *true*
    * Available region(s):
        * `lon1`

DigitalOcean supports the concept of an *image*, made by creating a *droplet* (VM) customising it and then saving as an
image. New VMs can be based on this image, rather than a default distribution. The degree to which an image is 
customised is down to the user, it could be very minimal, or could include a range of pre-installed packages, users and
other configuration.

As part of these templates Packer is used to build an image using, as far as possible, the same provisioning steps used
for Vagrant base boxes and OVA images. The major differences between the DigitalOcean image and these other types are:

* Source image - we cannot use our own ISO and instead pick from the set of base images that DigitalOcean supports. In
most cases has no consequence since the DigitalOcean base image and ISO we use are the same.
* No vagrant user is created - as these VMs are public (though not advertised) using a pre-shared private key is not a
good idea.

Images produced by this project are stored within the BAS DigitalOcean account [1] and **SHOULD** be used for any VM 
created within this service. This ensures consistency with other providers, and ensures that any customisations for
security or access are enforced or set out of the box.

The recommended method to create VMs using this image is to use [Terraform](https://www.terraform.io), with the BAS 
[terraform-module-digital-ocean-droplet](https://github.com/antarctica/terraform-module-digital-ocean-droplet) module.

## Build environment

The following software versions were used to produce the latest released artefact's:

* VirtualBox: version `4.3.30` with version `4.3.30` of the VirtualBox Guest Additions
* VMware: version `7.1.2` (and bundled VMware Tools version)
* Packer: version `0.8.6`

The host machine runs:

* Mac OS X: version `10.10.5`

## Requirements

To create new artefact's from these templates you will need the following software installed locally:

* Mac OS X or Linux
* [Packer](http://www.packer.io/docs/installation.html) `brew cask install packer` [1]
* [VirtualBox](http://www.virtualbox.org) `brew cask install virtualbox` [1]
* [VMware Fusion](http://www.vmware.com/products/fusion) `brew cask install vmware-fusion` [1] 
or [VMware Workstation](http://www.vmware.com/products/workstation) [3]
* [Ovftool](https://www.vmware.com/support/developer/ovf/) [2]
* An `ATLAS_TOKEN` environment variable set to your [Atlas access token](https://atlas.hashicorp.com/settings/tokens)
* An `DIGITALOCEAN_API_TOKEN` environment variable set to your DigitalOcean personal access token [4]

If testing Vagrant base boxes you will also need:

* [Vagrant](http://www.vagrantup.com) `brew cask install vagrant` [1]
* [Vagrant VMware plugin](www.vagrantup.com/vmware) `vagrant plugin install vagrant-vmware-fusion` [3]

[1] `brew cask` is a binary package manager for Mac OS X, you may need to find these applications yourself.

[2] On a Mac OS X you will probably need to add this to your path, i.e. `PATH="/Applications/VMware OVF Tool:$PATH"`

[3] If testing Vagrant base boxes on Linux install `vagrant-vmware-workstation` instead.

[4] Specifically for an account under the *basweb@bas.ac.uk* user.

## Setup

```shell
$ git clone ssh://git@stash.ceh.ac.uk:7999/baspack/packer-templates.git
$ cd packer-templates
```

## Usage

Note: You **MUST** set the release version to the next release (e.g. from 1.2.3, 2.0.0 for major, 1.3.0 for minor, 
1.2.4 for patch), by setting the `release_version` user variable in each template.

For each template there are two kinds, *desktop* and *cloud*:

* *Desktop* templates build from either a ISO image or existing VM files (e.g. a `.vmx`). They produce artifact's for 
desktop virtualisation tools, and also things like VMware vSphere and vCloud. 
* *Cloud* templates build from images provided by cloud providers. They produce artifacts specific to each provider,
such as DigitalOcean images or Amazon Web Services AMI's.

Typically you will build both kinds of template, 
e.g. `ubuntu-14.04-amd64-desktop.json` and `ubuntu-14.04-amd64-cloud.json`.

```shell
$ cd /templates
$ packer build [template]
```

Where: `[template]` is the name of a template in `/templates`.

E.g.

```shell
$ packer build ubuntu-14.04-amd64-desktop.json
```

Note: You can tell Packer to use a single builder using the `-only` option.

E.g.

```shell
$ packer build -only=vmware-iso ubuntu-14.04-amd64-desktop.json
```

For *desktop* templates, once built two types of artifact will be created in the `output` directory (per template):

* Vagrant base boxes in `output/base-boxes/boxes`
* VMs in `output/vms` [1] 

Note: The contents of `/output` **MUST NOT** be checked into source control.

[1] As an `.ova` file for VirtualBox and `vmx` directory for VMware

For *cloud* templates artifacts will be created and stored within each provider directly.

## Release/Deployment 

### Base boxes

#### Atlas

For discovery base boxes are automatically uploaded to Atlas, the default source of discovery for Vagrant.
These boxes are available publicly under the [Antarctica organisation](https://atlas.hashicorp.com/antarctica),
please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access. Once uploaded you will need to add a description 
for the new version, which should a change log since the last version.

#### S3

In addition, base boxes are currently stored in a S3 bucket for public access, this is to ensure boxes can be easily be
hosted elsewhere if Atlas is not a valid option in future (due to pricing, service changes, etc.). Please contact 
[Felix Fennell](mailto:felnne@bas.ac.uk) to access this bucket.

In future base boxes will be stored on the BAS SAN within the `/data/softwaredist` directory. 
They will then be accessible through [BAS Ramadda instance](ramadda.nerc-bas.ac.uk).

Relevant staff should already have write access to this directory, 
if not please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

Note: In future Ramadda will be used instead of S3.

Currently upload boxes to S3:

```
packages.calcifer.co/vagrant/baseboxes/[distro]/[version]/[architecture]/[box_version]/
```

E.g.

```
packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/1.0.0/
```

Note: Make sure to make all `.box` files world readable.

In future upload boxes to the SAN:

```
/data/softwaredist/vagrant/baseboxes/[distro]/[version]/[architecture]/[box_version]/
```

E.g.

```
/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/1.0.0/
```

#### Base box meta-data file

A meta-data JSON file is used to record details of the location of each version of a base box. 
These meta-data files are not strictly required but is recommended for forwards compatibility.

Add a relevant entry to the relevant meta-data file in `output/base-boxes/meta-files`.

You will need to calculate an SHA1 hash of each `.box` file listed in the new version [1].

Currently upload this file to S3 (see *base boxes* file sub-section for details) to the following location:

```
packages.calcifer.co/vagrant/baseboxes/[distro]/[version]/[architecture]/
```

E.g.

```
packages.calcifer.co/vagrant/baseboxes/ubuntu/14.04/amd64/
```

Note: Make sure to make all meta-data files world readable.

In future upload this file to the SAN:

```
/data/softwaredist/vagrant/baseboxes/[distro]/[version]/[architecture]/
```

E.g.

```
/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/
```

[1] on Mac OS X you can use `$ openssl sha1 <file>`.

### OVA files

As each builder creates VMs slightly differently, the steps to create an OVA file also differ.

OVA files are currently stored in a S3 bucket for public access, 
please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

In future OVA files will be stored on the BAS SAN within the `/data/softwaredist` directory. 
They will then be accessible through the [BAS Ramadda instance](ramadda.nerc-bas.ac.uk).

Relevant staff should already have write access to this directory, 
if not please contact [Felix Fennell](mailto:felnne@bas.ac.uk) for access.

Currently upload OVAs to S3:

```
packages.calcifer.co/ovas/[distro]/[version]/[architecture]/[box_version]/
```

E.g.

```
packages.calcifer.co/ovas/ubuntu/14.04/amd64/1.0.0/
```

Note: Make sure to make all `.ova` files world readable.

In future upload OVAs to the SAN:

```
/data/softwaredist/ovas/[distro]/[version]/[architecture]/[box_version]/
```

E.g.

```
/data/softwaredist/ovas/ubuntu/14.04/amd64/1.0.0/
```

#### VirtualBox (`virtualbox-iso`)

VirtualBox produces an OVA file natively, therefore no extra work is needed.

#### VMware (`vmware-iso`)

The `ovftool` is used to convert the `VMX` package to an `OVF` package, 
this is then converted manually into an `OVA` file.

Note: The `ovftool` can convert the `VMX` packages directly into `OVA` files, however critical meta-data is omitted.

```shell
$ mkdir scratch
$ ovftool [VMX] scratch/[OVF]
$ cd scratch
$ tar cf ../[OVA] *.ovf *.mf *-disk1.vmdk
$ cd ..
$ ovftool --schemaValidate [OVA]
$ rm -rf scratch
```

Where: `[VMX]` is the path to the `.vmx` file, `[OVF]` is the path of the `.ovf` file to create, 
`*` will be then name of VM produced (usually `vmware`) and `[OVA]`, the path of the `.ova` file to create.

Note: If `ovftool --schemaValidate` fails the OVA file will not work with ESXI (or other VMware products).

E.g.

```shell
$ cd output/vms/ubuntu-14.04-amd64-vmware-iso
$ mkdir scratch
$ ovftool vmware.vmx scratch/vmware.ovf
$ cd scratch
$ tar cf ../vmware.ova vmware.ovf vmware.mf vmware-disk1.vmdk
$ cd ..
$ ovftool --schemaValidate vmware.ova
$ rm -rf scratch
```

### DigitalOcean base images

Packer will automatically produce images from a temporary droplet created by Packer during building.

## Acknowledgements

Other than using the English Great Britain locale and an altered directory structure, 
these templates are the same as those found in the [Bento](https://github.com/opscode/bento) project from Chef. 

Therefore 97% of any credit for this project should go to Bento.
See their original notice file, `BENTO-NOTICE.md`, for further licensing information.

The authors of this project are incredibly grateful for their work.

## Contributing

This project welcomes contributions, see `CONTRIBUTING` for our general policy.

## Developing

### Committing changes

The [Git flow](sian.com/git/tutorials/comparing-workflows/gitflow-workflow) workflow is used to manage the development 
of this package.

* Discrete changes should be made within feature branches, created from and merged back into develop (where small 
changes may be made directly)
* When ready to release a set of features/changes, create a release branch from develop, update documentation as 
required and merge into master with a tagged, semantic version (e.g. v1.2.3)
* After each release, the master branch should be merged with develop to restart the process
* High impact bugs can be addressed in hotfix branches, created from and merged into master (then develop) directly

### Issue tracking

Issues, bugs, improvements, questions, suggestions and other tasks related to this package are managed through the 
BAS Web & Applications Team Jira project ([BASWEB](https://jira.ceh.ac.uk/browse/BASWEB)).

### License

Copyright 2015 NERC BAS. Licensed under the Apache License for compatibility with Bento, see `LICENSE` for details.
