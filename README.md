# Packer templates

A subset of [Packer](http://www.packer.io/) templates from the [Bento](https://github.com/opscode/bento) project for
desktop and cloud providers, customised to the English - Great Britain locale.

## Supported operating systems

Active support is provided for these operating systems, for the versions specified.
See the *pre-built artefacts* section for distribution/download links.

| Template Name       | Template version | Name                             | Vendor    | OS Version         | Architecture | Notes |
| ------------------- | ---------------- | -------------------------------- | --------- | ------------------ | ------------ | ----- |
| `antarctica/trusty` | 2.0.0            | [Ubuntu](http://www.ubuntu.com/) | Canonical | 14.04 LTS (Trusty) | AMD 64       | -     |

### Operating system customisations

Some customisations are made to these Operating systems using  provisioning scripts and installation options, these are 
summarised below:

| Template Name(s)    | Customisation                    | Rational                                             | Applicable Artefact Formats  | Notes |
| ------------------- | -------------------------------- | ---------------------------------------------------- | ---------------------------- | ----- |
| `antarctica/trusty` | Vagrant support                  | To enable Vagrant base box artefacts to be created   | *Vagrant base box* and *OVA* | -     |
| `antarctica/trusty` | Agent forwarding support in Sudo | To allow Git checkouts using PKI when acting as root | *All*                        | -     |

## Supported providers

Active support is provided for a range of desktop and cloud providers, for the versions specified.

| Provider            | Vendor       | Provider Version | Notes                                        |
| ------------------- | ------------ | ---------------- | -------------------------------------------- |
| VMware Fusion (Pro) | VMware       | 7.1.2 [1]        | [1]                                          |
| VMware Workstation  | VMware       | 11.1.2 [1]       | [1]                                          |
| VMware ESXi         | VMware       | 6.0 [1]          | And associated products such as vCentre. [1] |
| VirtualBox          | Oracle       | 4.3.30           | -                                            |
| DigitalOcean        | DigitalOcean | -                | -                                            |

[1] Because VMware Tools is not forwards compatible you must use a version of the relevant VMware product equal or lower
than shown in this table. This is a VMware limitation, not with Packer, Bento or us.

## Pre-built artefacts

Pre-compiled artefacts for the current version of each template are listed here. Except where otherwise stated artefacts
are made publicly available, under the same license as this project.

| Template            | Format             | Provider       | Distribution method | Distribution URL                                                                                                                                                                                   | Notes                                                                                    |
| ------------------- | ------------------ | -------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `antarctica/trusty` | Vagrant base box   | VMware         | Atlas / HTTPS       | [Atlas](https://atlas.hashicorp.com/antarctica/boxes/trusty/versions/2.1.0) / [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/2.0.0/vmware.box)  | Supports VMware Fusion and Workstation [1] [2]                                           |
| `antarctica/trusty` | Vagrant base box   | VirtualBox     | Atlas / HTTPS       | [Atlas](https://atlas.hashicorp.com/antarctica/boxes/trusty/versions/2.1.0) / [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/2.0.0/virtual.box) | Supports VMware Fusion and Workstation [1] [2]                                           |
| `antarctica/trusty` | OVA [3]            | VMware         | HTTPS               | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/2.0.0/vmware.ova)                                                                                             | Supports VMware Fusion, Workstation and ESXi                                             |
| `antarctica/trusty` | OVA [3]            | VirtualBox     | HTTPS               | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/2.0.0/virtualbox.ova)                                                                                         | -                                                                                        |
| `antarctica/trusty` | DigitalOcean Image | DigitalOcean   | Atlas               | [Atlas](https://atlas.hashicorp.com/antarctica/artifacts/trusty/types/digitalocean.droplet/1)                                                                                                      | Available only in the `lon1` region, includes private networking but not backups [1] [4] |

The recommended method to use DigitalOcean images is through [Terraform](https://www.terraform.io), using the BAS
[terraform-module-digital-ocean-droplet](https://github.com/antarctica/terraform-module-digital-ocean-droplet) module.

[1] Atlas artefacts are listed under the [Antarctica](https://atlas.hashicorp.com/antarctica).

[2] To use a base boxes list its name in a `Vagrantfile`, or follow the instructions in the
[Atlas documentation](https://atlas.hashicorp.com/help/vagrant/boxes/catalog).

[3] An OVA file is a [OVF](https://en.wikipedia.org/wiki/Open_Virtualization_Format) file compressed into a single file,
making it ideal for distribution.

[4] DigitalOcean images cannot be shared so this is not available publicly.

### BAS SAN distribution location

BAS Staff can also access these artefacts from the BAS SAN by replacing
`https://s3-eu-west-1.amazonaws.com/bas-packages-prod` in any HTTPS link with `/data/softwaredist`.

For example...

`https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/2.0.0/virtualbox.ova`

...would become

`/data/softwaredist/ovas/ubuntu/14.04/amd64/2.0.0/virtualbox.ova`

### Build environment

The following software versions were used to produce these artefact's:

* Mac OS X: version `10.10.5`
* VirtualBox: version `4.3.30` (with version `4.3.30` of the VirtualBox Guest Additions)
* VMware: version `7.1.2` (with bundled VMware Tools version)
* Packer: version `0.8.5`

### Older artefacts

Artefacts for older template releases are available on request. These artefacts are deprecated, non-supported and
**SHOULD NOT** be used. They **MUST NOT** be used in production environments or where available on the public internet.

See the *Feedback* section for contact information if you wish to request these older artefacts.

### Artefact indexes

TODO.

## Building artefacts

Artefacts are created by running the templates defined in this project through Packer. Manual or automatic methods are
then used to package and release artefacts for distribution.

Note: If you simply wish to use an artefact from this project please see the *Pre-built artefacts* section.

### Artefact formats

Multiple artefacts are produced for each template. These include Vagrant base boxes, OVA files and various images for
cloud providers.

#### Vagrant base boxes

A specially packaged Virtual Machine for use with [Vagrant](https://www.vagrantup.com).

Packer builds base boxes from a downloaded ISO file, which it installs into a VM and then configures.

Base boxes have to meet certain criteria to be compatible with Vagrant. For templates in this project support for this
is provided by the Bento project. Base boxes are provider specific and in some cases require additional Vagrant plugins
before they can be used. For more information see the [Vagrant documentation](https://docs.vagrantup.com/v2/).

Packer will package base boxes and upload them to Atlas automatically for distribution. Boxes will need to be manually 
copied to Amazon S3 (for HTTPS distribution) and the BAS SAN (for BAS SAN distribution).

#### OVA files

A compressed [OVF](http://en.wikipedia.org/wiki/Open_Virtualization_Format) image for use with most virtualisation
products.

OVA files are produced as a by-product of Vagrant base boxes, they are therefore identical except in how they are
packaged. This means OVA files are built from the same ISO file and include things required for Vagrant, such as a 
`vagrant` user and password-less sudo.

Packer will create OVA files for some providers, whereas others require manual creation. OVAs will need to be manually 
copied to Amazon S3 (for HTTPS distribution) and the BAS SAN (for BAS SAN distribution).

#### DigitalOcean images

A DigitalOcean image represents the saved state of a previously created Droplet (VM) from which new Droplets can be 
based upon. 

Packer builds DigitalOcean images using one the pre-defined base images provided by DigitalOcean [1] to create a new 
Droplet. It then configures the droplet, saves it as an image with the users DigitalOcean account and destroys before 
destroying the Droplet.

The DigitalOcean base images are minimal installations of each operating system, very similar to VMs produced using 
the ISO file. One key difference between DigitalOcean images and Vagrant base boxes, for example, is the absence of a 
`vagrant` user as this isn't needed.

Packer will create Artefacts to reference DigitalOcean images in Atlas automatically.

[1] User images must be based on a DigitalOcean defined image, it is not possible to upload and build from an ISO file.

### Requirements

To build artefacts from these template you will need the following software installed locally:

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

[2] On Mac OS X you will probably need to add this directory to your path, `PATH="/Applications/VMware OVF Tool:$PATH"`

[3] If testing Vagrant base boxes on Linux install `vagrant-vmware-workstation` instead.

[4] Specifically for a team account delegated from the *basweb@bas.ac.uk* user.

## Setup

Clone and enter this project:

```shell
$ git clone git@github.com:antarctica/packer-templates.git
$ cd packer-templates
```

## Usage

Each template within this project is split into multiple template files, each targeting different artefact formats:

* `-desktop` templates build *Vagrant base boxes* and *OVA files*
* `-cloud` templates build *DigitalOcean images*

Template files are built separately using the `packer build` command, typically all template files for a template will
be built.

Note: Before building, you **MUST** set the `release_version` user variable in each template file using 
[semantic versioning](http://semver.org/spec/v2.0.0.html).

```shell
$ cd /templates
$ packer build [template]
```

Where: `[template]` is the a template file of a template in `/templates`.

E.g.

```shell
$ packer build ubuntu-14.04-amd64-desktop.json
```

Note: You can tell Packer to use a single builder (provider) using the `-only` option.

E.g.

```shell
$ packer build -only=vmware-iso ubuntu-14.04-amd64-desktop.json
```

## Packaging/Distribution

Some artefact formats are packages and uploaded from distribution automatically by Packer, for other formats manual 
packaging and/or uploading is required.

### Vagrant base boxes

Packer will automatically compress and package Vagrant base boxes as required.

#### Atlas

Packaged base boxes will be uploaded to Atlas automatically (this may take some time, base boxes are roughly 500MB each).
Uploaded artefacts will be versioned using the `release_version` user variable set in the Packer template file.
Artefacts for each provider are grouped by release.

Additional meta-data will need to be added to provide a relevant change log since the last version.

> Not refactored below this line!

#### S3

TODO

#### BAS SAN

TODO

### OVA files

TODO.

### DigitalOcean images

TODO.

For each *desktop* template environment, two types of artefact will be created in the `output` directory:

* Vagrant base boxes in `output/base-boxes/boxes`
* VMs in `output/vms` [1]

Note: The contents of `/output` **MUST NOT** be checked into source control.

[1] As an `.ova` file for VirtualBox and `vmx` directory for VMware

For each *cloud* template environment, relevant artefacts will be created and stored within each provider directly.

## Release/Deployment

### Base boxes

#### Atlas

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
These meta-data files are not strictly required but are recommended for forwards compatibility.

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

As each builder creates VMs slightly differently, the steps to create an OVA file differ.

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
$ ovftool packer-vmware-iso.vmx scratch/vmware.ovf
$ cd scratch
$ tar cf ../vmware.ova vmware.ovf vmware.mf vmware-disk1.vmdk
$ cd ..
$ ovftool --schemaValidate vmware.ova
$ rm -f scratch
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
