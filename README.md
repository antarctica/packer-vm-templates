# BAS Packer VM Templates

A subset of customised [Packer](http://www.packer.io/) templates from [Bento](https://github.com/opscode/bento) to 
act as localised, minimal, base images for desktop and cloud providers.

## Supported operating systems

Active support is provided for these operating systems, for the versions specified.
See the *pre-built artefacts* section for distribution/download links.

| Template Name                 | Template Version | Status | Distribution Name                | Distribution Version | Distribution Architecture | Notes   |
| ----------------------------- | ---------------- | ------ | -------------------------------- | -------------------- | ------------------------- | ------- |
| `antarctica/trusty`           | 3.2.0            | Mature |[Ubuntu](http://www.ubuntu.com/)  | 14.04 LTS (Trusty)   | AMD 64                    | -       |
| `antarctica/trusty-vdirector` | 0.1.1            | New    |[Ubuntu](http://www.ubuntu.com/)  | 14.04 LTS (Trusty)   | AMD 64                    | [1] [2] |
| `antarctica/centos7`          | 0.6.1            | New    |[CentOS](https://www.centos.org/) | 7.1                  | x86_64                    | -       |

Note: The *status* attribute represents how stable a template is. New templates will be listed as *New* and may contain
teething issues, such as small bugs or performance issues. Once these are fixed, templates will marked as *Mature*. This
does not mean mature templates cannot be improved, rather that they are expected to work in most cases.

Note: As using the `/` character is problematic with file systems an alternative template using a `-` character is used
instead. For example a template named `antarctica/trusty` would alternatively be referred to as `antarctica-trusty`.

[1] Required as vDirector requires a vApp OVF, which can only be produced using vCentre. BAS currently only has access
to vCentre 4.x which is limited to VMware hardware version 7. By default Packer produces VMs with hardware version 9.
This template is therefore a temporary requirement to produce a version of the 'antarctica/trusty' template with the 
lower hardware version, until a newer version of vCentre is available.

[2] This template uses all customisations applicable to the 'antarctica/trusty' template, version 3.2.0.

### Operating system customisations

Some customisations are made to these Operating systems using  provisioning scripts and installation options, these are
summarised below:

| Template Name(s)     | Since | Customisation                                                 | Rational                                                         | Applicable Artefact Formats                  | Notes |
| -------------------- | ----- | ------------------------------------------------------------- | ---------------------------------------------------------------- | -------------------------------------------- | ----- |
| `antarctica/trusty`  | 0.1.0 | Vagrant support                                               | To enable Vagrant base box artefacts to be created               | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/trusty`  | 0.1.0 | Locale & keyboard layout set to UK                            | To suit UK hardware and use nearby package mirrors               | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/trusty`  | 1.0.0 | Basing template of the Bento project                          | No more reinventing the wheel, much smaller artefacts            | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/trusty`  | 2.0.0 | Agent forwarding support in Sudo                              | To allow Git checkouts using PKI when acting as root             | *All*                                        | -     |
| `antarctica/trusty`  | 3.0.0 | System firewall enabled by default, with an exception for SSH | For basic system security whilst allowing remote management      | *All*                                        | -     |
| `antarctica/trusty`  | 3.1.0 | Adding template information to an Ansible local facts file    | For registering instances of this template in system inventories | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/trusty`  | 3.2.0 | Removing SSH host keys                                        | To ensure unique host keys to be used for each instance          | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/centos7` | 0.1.0 | SELinux set to "permissive"                                   | To be compatible with some legacy BAS projects                   | *All except AMI*                             | [1]   |
| `antarctica/centos7` | 0.1.0 | Root password set to "password"                               | To emphasise that this is not a secure default                   | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/centos7` | 0.1.0 | Agent forwarding support in Sudo                              | To allow Git checkouts using PKI when acting as root             | *All*                                        | -     |
| `antarctica/centos7` | 0.2.0 | Password-less sudo enabled for members of the 'wheel' group   | To allow provisioning tools to perform sudo actions              | *All*                                        | -     |
| `antarctica/centos7` | 0.3.0 | System firewall enabled by default, with an exception for SSH | For basic system security whilst allowing remote management      | *All*                                        | -     |
| `antarctica/centos7` | 0.4.0 | UID for Vagrant user set to '900'                             | For consistency with Ubuntu and allow users to start from 1000   | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/centos7` | 0.5.0 | Adding template information to an Ansible local facts file    | For registering instances of this template in system inventories | *Vagrant base box* and *OVA*                 | -     |
| `antarctica/centos7` | 0.6.0 | Removing SSH host keys                                        | To ensure unique host keys to be used for each instance          | *Vagrant base box* and *OVA*                 | -     |

Note: The above list does not include customisations made by the Bento project.

[1] It is not currently possible to disable SELinux on *AMI* artefacts, 
see [BASWEB-500](https://jira.ceh.ac.uk/browse/BASWEB-500) for details.

## Supported providers

Active support is provided for a range of desktop and cloud providers, for the versions specified.

| Provider            | Vendor              | Provider Version | Notes                                        |
| ------------------- | ------------------- | ---------------- | -------------------------------------------- |
| VMware Fusion (Pro) | VMware              | 8.1.0            | [1]                                          |
| VMware Workstation  | VMware              | 11.1.2           | [1]                                          |
| VMware ESXi         | VMware              | 6.0              | And associated products such as vCentre. [1] |
| VirtualBox          | Oracle              | 5.0.10           | -                                            |
| DigitalOcean        | DigitalOcean        | -                | -                                            |
| EC2                 | Amazon Web Services | -                | -                                            |
| VMware vDirector    | vDirector           | Unknown          | [2]                                          |

[1] Because VMware Tools is not forwards compatible you must use a version of the relevant VMware product equal or lower
than shown in this table. This is a VMware limitation, not with Packer, Bento or us.

[2] Extremely experimental! Only the 'antarctica/trusty-vdirector' template is supported for this provider.

## Pre-built artefacts

Pre-compiled artefacts for the current version of each template are listed here. Except where otherwise stated artefacts
are made publicly available, under the same license as this project.

| Template                      | Format               | Status | Provider         | Distribution Method & URL                                                                                                                                                                                   | Notes                                                                                    |
| ----------------------------- | -------------------- | ------ | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `antarctica/trusty`           | Vagrant base box     | Mature | VMware Desktop   | [Atlas](https://atlas.hashicorp.com/antarctica/boxes/trusty/versions/3.2.0) / [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/3.2.0/vmware.box)  | Supports VMware Fusion and Workstation [1] [2]                                           |
| `antarctica/trusty`           | Vagrant base box     | Mature | VirtualBox       | [Atlas](https://atlas.hashicorp.com/antarctica/boxes/trusty/versions/3.2.0) / [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/3.2.0/virtual.box) | Supports VMware Fusion and Workstation [1] [2]                                           |
| `antarctica/trusty`           | OVA [3]              | Mature | VMware Desktop   | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/3.2.0/vmware.ova)                                                                                             | Supports VMware Fusion, Workstation and ESXi                                             |
| `antarctica/trusty`           | OVA [3]              | Mature | VirtualBox       | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/3.2.0/virtualbox.ova)                                                                                         | -                                                                                        |
| `antarctica/trusty`           | DigitalOcean Image   | Mature | DigitalOcean     | [Atlas](https://atlas.hashicorp.com/antarctica/artifacts/trusty/types/digitalocean.droplet/5)                                                                                                      | Available only in the `lon1` region, includes private networking but not backups [1] [4] |
| `antarctica/trusty`           | Amazon Machine Image | New    | EC2              | [Atlas](https://atlas.hashicorp.com/antarctica/artifacts/trusty/types/amazon.ami/5)                                                                                                                | Available only in the `eu-west-1` region                                                 |
| `antarctica/trusty-vdirector` | Zipped OVF           | New    | VMware vDirector | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/3.2.0/vmware-vdirector-0.1.1.ovf.zip)                                                                         | Supports VMware vDirector [7] [8]                                                           |
| `antarctica/centos7`          | Vagrant base box     | New    | VMware Desktop   | [Atlas](https://atlas.hashicorp.com/antarctica/boxes/centos7/versions/0.6.1) / [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/centos/7.1/x86_64/0.6.1/vmware.box)  | Supports VMware Fusion and Workstation [1] [2]                                           |
| `antarctica/centos7`          | Vagrant base box     | New    | VirtualBox       | [Atlas](https://atlas.hashicorp.com/antarctica/boxes/centos7/versions/0.6.1) / [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/centos/7.1/x86_64/0.6.1/virtual.box) | Supports VMware Fusion and Workstation [1] [2]                                           |
| `antarctica/centos7`          | OVA [3]              | New    | VMware           | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/centos/7.1/x86_64/0.6.1/vmware.ova)                                                                                              | Supports VMware Fusion, Workstation and ESXi                                             |
| `antarctica/centos7`          | OVA [3]              | New    | VirtualBox       | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/centos/7.1/x86_64/0.6.1/virtualbox.ova)                                                                                          | -                                                                                        |
| `antarctica/centos7`          | DigitalOcean Image   | New    | DigitalOcean     | [Atlas](https://atlas.hashicorp.com/antarctica/artifacts/centos7/types/digitalocean.droplet/8)                                                                                                     | Available only in the `lon1` region, includes private networking but not backups [1] [4] |
| `antarctica/centos7`          | Amazon Machine Image | New    | EC2              | [Atlas](https://atlas.hashicorp.com/antarctica/artifacts/centos7/types/amazon.ami/7)                                                                                                               | Available only in the `eu-west-1` region [6]                                             |

The recommended method to use DigitalOcean images is through [Terraform](https://www.terraform.io), using the BAS
[terraform-module-digital-ocean-droplet](https://github.com/antarctica/terraform-module-digital-ocean-droplet) module.

The recommended method to use EC2 AMIs is through [Terraform](https://www.terraform.io).

Note: The *status* attribute represents how stable an artefact is. New artefacts will be listed as *New* and may contain
teething issues, such as small bugs or performance issues. Once these are fixed, artefacts will marked as *Mature*. This
does not mean mature artefacts cannot be improved, rather that they are expected to work in most cases.

[1] Atlas artefacts are listed under the [Antarctica](https://atlas.hashicorp.com/antarctica).

[2] To use a base boxes list its name in a `Vagrantfile`, or follow the instructions in the
[Atlas documentation](https://atlas.hashicorp.com/help/vagrant/boxes/catalog).

[3] An OVA file is a [OVF](https://en.wikipedia.org/wiki/Open_Virtualization_Format) file compressed into a single file,
making it ideal for distribution.

[4] DigitalOcean images cannot be shared so this is not available publicly.

[5] SELinux is **NOT** disabled on this artefact, see [this issue](https://jira.ceh.ac.uk/browse/BASWEB-500) for further
details.

[6] Despite being free the CentOS base AIM carries a license agreement which prevents the built artefact from being
shared publicly. To use this AMI you must be assigned permissions. Please get in touch using the information in the
*Feedback* section if you wish to use this artefact.

[7] These artefacts are essentially an addition to artefacts produced for the 'antarctica/trusty' template and as such 
are located within the directory structure for the 'antarctica/trusty' template.

[8] vDirector templates are also listed in the shared *BAS-Base-Images* catalogue within the *PolarView* tenancy in 
the JASMIN unmanaged cloud vDirector instance. To use these templates in other vDirector instances, download the zipped 
OVF file and upload to your own instance.

Note: Currently access to this catalogue is restricted to members of the *PolarView* tenancy, this is being addressed 
with JASMIN support. Until this is fixed, follow the instructions above for users of other vDirector instances to load
these templates into a catalogue within another tenancy.

### BAS SAN distribution location

BAS Staff can also access these artefacts from the BAS SAN by replacing
`https://s3-eu-west-1.amazonaws.com/bas-packages-prod` in any HTTPS link with `/data/softwaredist`.

For example...

`https://s3-eu-west-1.amazonaws.com/bas-packages-prod/ovas/ubuntu/14.04/amd64/2.0.0/virtualbox.ova`

...would become

`/data/softwaredist/ovas/ubuntu/14.04/amd64/2.0.0/virtualbox.ova`

Note: The BAS SAN is used as the canonical storage location for records management.

### Build environment

The following software versions were used to produce these artefact's:

* Mac OS X: version `10.10.5`
* VirtualBox: version `5.0.10` (with version `5.0.10` of the VirtualBox Guest Additions)
* VMware: version `8.1.0` (with bundled VMware Tools version)
* Packer: version `0.8.6`

### Older artefacts

Artefacts for older template releases are available on request. These artefacts are deprecated, non-supported and
**SHOULD NOT** be used. They **MUST NOT** be used in production environments or where available on the public internet.

See the *Feedback* section for contact information if you wish to request these older artefacts.

### Artefact indexes

A JSON file is provided for each template containing Vagrant base box artefacts. It lists, for each artefact version,
the HTTPS distribution URL, SHA1 checksum of the box and the provider it targets.

Note: These indexes are not supported, they are provided for legacy reasons when Vagrant base boxes were self hosted.
They may be removed at any time.

| Template Name        | Index URL                                                                                                                  | Notes |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------- | ----- |
| `antarctica/trusty`  | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/antarctica-trusty.json)  | -     |
| `antarctica/centos7` | [HTTPS](https://s3-eu-west-1.amazonaws.com/bas-packages-prod/vagrant/baseboxes/centos/7.1/x86_64/antarctica-centos7.json)  | -     |

### Accessing template information from within instances

Templates include details about themselves in an INI formatted meta-data file. This is useful for querying the version 
of a template used in an instance for a system inventory for example.

Meta-data Location: `/etc/ansible/facts.d/os_template.fact`

Meta-data contents:

| Key        | Represents                | Example             | Notes |
| ---------- | ------------------------- | ------------------- | ----- |
| *name*     | Template name             | `antarctica/trusty` | -     |
| *name_alt* | Alternative template name | `antarctica-trusty` | -     |
| *version*  | Template version          | `3.1.0`             | -     |

Note: All meta-data is grouped under a `general` section.

Note: This meta-data is stored to be compatible with Ansible 
[Local Facts](http://docs.ansible.com/ansible/playbooks_variables.html#local-facts-facts-d) but can be used for other
purposes as needed.

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

Packer builds DigitalOcean images using one the pre-defined base images provided by DigitalOcean to create a new
Droplet. It then configures the droplet, saves it as an image with the users DigitalOcean account before destroying the
Droplet.

The base images used are indicated below, they are minimal installations of each Operating System provided by
DigitalOcean. These images differ little from VMs produced using ISO files, except where required to run under
DigitalOcean.

| Template name        | Base Image         | Provider     | Notes |
| -------------------- | ------------------ | ------------ | ----- |
| `antarctica/trusty`  | `ubuntu-14-04-x64` | DigitalOcean | -     |
| `antarctica/centos7` | `centos-7-0-x64`   | DigitalOcean | -     |

Packer will create Artefacts to reference DigitalOcean images in Atlas automatically.

Note: These images do not include a `vagrant` user, as this is not needed for cloud images.

#### Amazon Machine Images (AMIs)

An Amazon Machine Image represents the saved state of previously created Amazon EC2 instance (VM) from which new
instances can be based upon.

Packer builds AMIs using one of the pre-defined, public, AMIs provided through the Amazon AMI Marketplace to create a
new EC2 instance. It then configures the instance, saves it as an AMI within the users Amazon Web Services account
before terminating the instance.

The base AMIs used are indicated below, they are official, minimal, installations of each Operating System provided by
the relevant distribution. These AMIs differ little from VMs produced using ISO files, except where required to run
under EC2. One difference is the absence of a `vagrant` user, as this is not needed for cloud images.

| Template name        | Base AMI                                                         | Provider                                                                                               | Notes |
| -------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----- |
| `antarctica/trusty`  | [ami-47a23a30](https://aws.amazon.com/marketplace/pp/B00JV9TBA6) | [Canonical](https://aws.amazon.com/marketplace/seller-profile?id=565feec9-3d43-413e-9760-c651546613f2) | -     |
| `antarctica/centos7` | [ami-e4ff5c93](https://aws.amazon.com/marketplace/pp/B00O7WM7QW) | [CentOS](https://aws.amazon.com/marketplace/seller-profile?id=16cb8b03-256e-4dde-8f34-1b0f377efe89)    | -     |

Packer will create Artefacts to reference AMIs in Atlas automatically.

Note: These images do not include a `vagrant` user, as this is not needed for cloud images.

Note: Additional elements required to use an EC2 instance, as such security groups, SSH keys, etc. are not defined as
part of the AMI. These additional elements will therefore need to be provided at runtime, ideally through a provisioning
tool.

#### VMware vApps

A vApp represents a logical collection of virtual machines used within some VMware products, including vCentre and 
vDirector.

Packer cannot build vApps directly as this is not a supported format for VMware desktop applications. Instead Packer is
used to build a standard OVF file (packaged as an OVA) and this is then imported into vCentre and converted into a vApp
containing the Packer built VM.

This vApp is then exported as an OVF and compressed to a single file for easier distribution. Zipped OVFs will need to 
be manually copied to Amazon S3 (for HTTPS distribution) and the BAS SAN (for BAS SAN distribution).

Note: In future this artefact will produced from the 'OVA' artefacts (for VMware) to reduce complexity. Currently it is
not possible to do this due to incompatible VMware hardware versions.

Note: Support for vApps is currently very experimental and may contain settings, names or meta-data that are specific
to BAS. Where possible these will be removed, or changed to more generic values, as testing for vApps continues.

### Requirements

To build artefacts from these template you will need the following software installed locally:

* Mac OS X or Linux
* [Packer](http://www.packer.io/docs/installation.html) `brew cask install packer` [1]
* [VirtualBox](http://www.virtualbox.org) `brew cask install virtualbox` [1]
* [VMware Fusion](http://www.vmware.com/products/fusion) `brew cask install vmware-fusion` [1]
or [VMware Workstation](http://www.vmware.com/products/workstation) [3]
* [Ovftool](https://www.vmware.com/support/developer/ovf/) [2]

You will also need:

* An `ATLAS_TOKEN` environment variable set to your [Atlas access token](https://atlas.hashicorp.com/settings/tokens)
* An `DIGITALOCEAN_API_TOKEN` environment variable set to your DigitalOcean personal access token [4]
* An `AWS_ACCESS_KEY_ID` environment variable set to your AWS access key ID, and both `AWS_ACCESS_KEY_SECRET` and
`AWS_SECRET_ACCESS_KEY` environment variables set to your AWS Access Key [5]
* Suitable permissions within AWS to create/destroy EC2 instances, AMIs, security groups, key-pairs, etc.
* Access to the `bas-packages-prod` S3 bucket
* A private key with access to `bslcene.nerc-bas.ac.uk` located as `~/.ssh/id_rsa` [6]
* Write access to the `/data/softwaredist` volume [7]

If testing Vagrant base boxes you will also need:

* [Vagrant](http://www.vagrantup.com) `brew cask install vagrant` [1]
* [Vagrant VMware plugin](www.vagrantup.com/vmware) `vagrant plugin install vagrant-vmware-fusion` [3]

[1] `brew cask` is a binary package manager for Mac OS X, you may need to find these applications yourself.

[2] On Mac OS X you will probably need to add this directory to your path, `PATH="/Applications/VMware OVF Tool:$PATH"`

[3] If testing Vagrant base boxes on Linux install `vagrant-vmware-workstation` instead.

[4] Specifically for a user account delegated from the *basweb@bas.ac.uk* team account.

[5] Specifically for a user account delegated from the BAS AWS account, use the
[IAM Console](https://console.aws.amazon.com/iam/home?region=eu-west-1) to generate access keys.

[6] See [here](https://help.github.com/articles/generating-ssh-keys/) for instructions on how to generate a private key,
contact the [BAS ICT helpdesk](mailto:helpdesk@bas.ac.uk) if need help enabling this key to access BAS servers.

[7] Contact the [BAS ICT helpdesk](mailto:helpdesk@bas.ac.uk) if you don't have this access.

## Setup

Clone and enter this project:

```shell
$ git clone git@github.com:antarctica/packer-templates.git
$ cd packer-templates
```

## Usage

### Standard builds

If you are generating all templates within this project, this is known as a *standard build*.

As these involve preparation, running packer multiple times for different templates, followed by packaging and release 
steps, a shell script to automate as much of this process is included for convenience.

This shell script is designed for this use-case only. It is not intended to be configurable or flexible to meet any
custom needs.

To launch the script - which is non-interactive once template versions have been specified, run:

```shell
$ ./standard-build.sh
```

Note: The standard build script does not update artefact lists, you will need to do this manually using the SHA1 hashes
generated by the script.

### Manual builds

Each template within this project is split into multiple template files, each targeting different artefact formats:

* `-desktop` templates build *Vagrant base boxes* and *OVA files*
* `-cloud` templates build *DigitalOcean images* and *AMIs*

Template files are built separately using the `packer build` command, typically all template files for a template will
be built.

Note: You **MUST** set the `release_version` user variable in each template file using 
[semantic versioning](http://semver.org/spec/v2.0.0.html).

```shell
$ packer build -var 'release_version=[Template version]' templates/[Template alternate name]-[Template file (desktop/cloud)]
```

E.g.

```shell
$ packer build -var 'release_version=1.2.3' templates/antarctica-trusty-desktop.json
```

Note: You can tell Packer to use a single builder (provider) using the `-only` option.

E.g.

```shell
$ packer build -only=vmware-iso -var 'release_version=1.2.3' templates/antarctica-trusty-desktop.json
```

## Packaging/Distribution

Some artefact formats are packages and uploaded from distribution automatically by Packer, for other formats manual
packaging and/or uploading is required.

Note: You do not need to do this if you have used the standard build script, *except* for the artefact lists.

### Vagrant base boxes

Packer will automatically compress and package Vagrant base boxes as required.

#### Artefact lists

A JSON file is provided for each template containing Vagrant base box artefacts. It lists, for each artefact version,
the HTTPS distribution URL, SHA1 checksum of the box and the provider it targets.

Add a new entry to the relevant artefact list in `artefacts/vagrant-base-boxes/artefact-lists`, following the pattern
for previous releases. You will need to calculate an SHA1 hash for each `.box` file [1].

The `bas-packages-prod` bucket is used to hold these lists. This bucket is stored under the BAS AWS account and should
be accessible to all account users by default. If this is not the case please get in touch using the information in the
*feedback* section.

Note: This bucket has a permissions policy to allow anonymous read on all objects (but not directories or ACLs).

Artefact lists should be stored using the following directory and file name structure:

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/[Template distribution name]/[Template distribution version]/[Template architecture]/[Template alternate name].json artefacts/vagrant-base-boxes/artefact-lists/[Template alternate name].json
```

E.g.

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/antarctica-trusty.json artefacts/vagrant-base-boxes/artefact-lists/antarctica-trusty.json
```

[1] on Mac OS X you can use `$ openssl sha1 <file>`.

#### Atlas

Packaged base boxes will be uploaded to Atlas automatically (this may take some time, base boxes are roughly 500MB each).
Uploaded artefacts will be versioned using the `release_version` user variable set in the Packer template file.
Artefacts for each provider are grouped by release.

Additional meta-data will need to be manually added to provide a relevant change log since the last version.

#### S3

Amazon S3 is used an external alternative to Atlas in case this service becomes unsuitable in the future (due to
pricing, feature changes, etc.).

The `bas-packages-prod` bucket is used to hold base box artefacts. This bucket is stored under the BAS AWS account and
should be accessible to all account users by default. If this is not the case please get in touch using the information
in the *feedback* section.

Note: This bucket has a permissions policy to allow anonymous read on all objects (but not directories or ACLs).

Base boxes should be stored using the following directory and file name structure:

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]/[Base box provider].box artefacts/vagrant-base-boxes/base-boxes/[Template alternate name]/[Packer builder].box
```

E.g.

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/0.0.0/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box
```

#### BAS SAN

The BAS SAN is used an internal alternative to Atlas in case this service becomes unsuitable in the future (due to
pricing, feature changes, etc.). This location also acts as the canonical storage location for records management.

The `/data/softwaredist` SAN volume is used to hold base box artefacts. This volume is writeable to all members of the
`swpack` Unix group, which should include all relevant staff. Contact the [BAS ICT helpdesk](mailto:helpdesk@bas.ac.uk)
if you don't have this access.

Note: This volume has a permissions policy to allow anonymous read on all directories and files.

Base boxes should be stored using the following directory structure:

```shell
$ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vagrant/baseboxes/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]
```

Base boxes should be stored using the following file name structure:

```shell
$ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]/[Base box provider].box artefacts/vagrant-base-boxes/base-boxes/[Template alternate name]/[Packer builder].box
```

E.g.

```shell
$ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/0.0.0
$ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/0.0.0/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box
```

### OVA files

Each Packer builder differs in how OVA files are created:

#### VirtualBox (`virtualbox-iso`)

The VirtualBox provider produces an OVA file natively, therefore no extra work is needed.

See the *S3* and *BAS SAN* sub-sections of this section for instructions on distributing OVA files.

#### VMware (`vmware-iso`)

The VMware builder produces a VM directory in its native format, a `.vmx` file with associated support files.
This needs to be converted into an OVA file using the *OVFTool* utility prior to distribution.

See the *S3* and *BAS SAN* sub-sections of this section for instructions on distributing OVA files.

Note: Due to a bug, the `.vmx` file must be first converted to an OVF package, then into an OVA file using these steps:

```shell
$ cd [VMX directory]

$ mkdir scratch
$ ovftool vmware.vmx scratch/vmware.ovf
$ cd scratch
$ tar cf ../vmware.ova vmware.ovf vmware.mf vmware-disk1.vmdk
$ cd ..
$ ovftool --schemaValidate vmware.ova
$ rm -rf scratch
```

Where: `[VMX directory]` is the path containing the `.vmx` file.

Note: If `ovftool --schemaValidate` fails the OVA file will not work when deployed into a VMware product.

#### S3

The `bas-packages-prod` bucket is used to hold OVA artefacts. This bucket is stored under the BAS AWS account and
should be accessible to all account users by default. If this is not the case please get in touch using the information
in the *feedback* section.

Note: This bucket has a permissions policy to allow anonymous read on all objects (but not directories or ACLs).

OVA files should be stored using the following directory and file name structure:

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]/[Provider].ova artefacts/ovas/[Template alternate name]-[Packer builder]/[Provider].ova
```

E.g.

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/ubuntu/14.04/amd64/0.0.0/vmware.ova artefacts/ovas/antarctica-trusty-vmware-iso/vmware.ova
```

#### BAS SAN

The BAS SAN is used as the canonical storage location for records management.

The `/data/softwaredist` SAN volume is used to hold OVA artefacts. This volume is writeable to all members of the
`swpack` Unix group, which should include all relevant staff. Contact the [BAS ICT helpdesk](mailto:helpdesk@bas.ac.uk)
if you don't have this access.

Note: This volume has a permissions policy to allow anonymous read on all directories and files.

OVA files should be stored using the following directory structure:

```shell
$ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/ovas/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]
```

OVA files should then be stored using the following file name structure:

```shell
$ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]/[Provider].ova artefacts/ovas/[Template alternate name]-[Packer builder]/[Provider].ova
```

E.g.

```shell
$ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/ovas/ubuntu/14.04/amd64/0.0.0
$ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/ubuntu/14.04/amd64/0.0.0/vmware.ova artefacts/ovas/antarctica-trusty-vmware-iso/vmware.ova
```

### DigitalOcean images

Packer will automatically store DigitalOcean images within the DigitalOcean account Packer is configured to use.

### Amazon Machine Images

Packer will automatically store AMIs within the Amazon Web Services account Packer is configured to use.

#### VMware vApps

The VMware builder produces a VM directory in its native format, a `.vmx` file with associated support files.
This needs to be converted into an OVA file using the *OVFTool* utility prior to deployment to vCentre and conversion 
to a vApp. This will then be exported as a zipped OVF file.

See the *S3* and *BAS SAN* sub-sections of this section for instructions on distributing zipped OVF files.
See the *vDirector* sub-section of this section for instructions on loading zipped OVF files into a vDirector catalogue.

Note: Due to a bug, the `.vmx` file must be first converted to an OVF package, then into an OVA file using these steps:

```shell
$ cd [VMX directory]

$ mkdir scratch
$ ovftool vmware.vmx scratch/vmware.ovf
$ cd scratch
$ tar cf ../vmware.ova vmware.ovf vmware.mf vmware-disk1.vmdk
$ cd ..
$ ovftool --schemaValidate vmware.ova
$ rm -rf scratch
```

Where: `[VMX directory]` is the path containing the `.vmx` file.

Note: If `ovftool --schemaValidate` fails the OVA file will not work when deployed into a VMware product.

Covert this OVA file to a vApp using vCentre using 
[these steps](https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc_50%2FGUID-2A95EBB8-1779-40FA-B4FB-4D0845750879.html).

Note: You will need to contact ICT to have the OVA file converted to a vApp [1], ensure you request the following:

* All networks are removed from the inner VM to prevent errors when provisioning automatically in vDirector
* The name of the inner VM is set to `node1` to be suitably generic 

The vApp will typically be exported as an OVA file, these cannot be read by vDirector and so need to be converted to an
OVF file.

```shell
$ mkdir vmware-vapp
$ ovftool [vapp].ova vmware-vapp/vmware-vapp.ovf
$ ovftool --schemaValidate vmware-vapp/vmware-vapp.ovf
```

Where: `[vapp]` is the file name of the vApp exported from vCentre.

Note: Ovftool may complain about a missing manifest entry for the virtual hard disk (`[vapp]-disk1.vmdk`), this is fine
as it relates to the input OVA file, not the OVF file produced (the manifest for which includes all relevant entries).

For distribution the OVF file is compressed as a zip archive:

```shell
$ cd vmware-vapp
$ zip ../vmware-vapp.ovf.zip -r vmware-vapp-disk1.vmdk vmware-vapp.mf vmware-vapp.ovf
$ cd ..
$ rm -rf vmware-vapp
```

[1] Specifically [Jeremy Robst](mailto:jpro@bas.ac.uk)

#### S3

The `bas-packages-prod` bucket is used to hold vApp artefacts. This bucket is stored under the BAS AWS account and
should be accessible to all account users by default. If this is not the case please get in touch using the information
in the *feedback* section.

Note: This bucket has a permissions policy to allow anonymous read on all objects (but not directories or ACLs).

vApp files should be stored using the following directory and file name structure:

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vapps/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]/[Provider]-vapp.ovf.zip [Provider]-vapp.ovf.zip
```

E.g.

```shell
$ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vapps/ubuntu/14.04/amd64/0.0.0/vmware-vapp.ovf.zip vmware-vapp.ovf.zip
```

#### BAS SAN

The BAS SAN is used as the canonical storage location for records management.

The `/data/softwaredist` SAN volume is used to hold vApp artefacts. This volume is writeable to all members of the
`swpack` Unix group, which should include all relevant staff. Contact the [BAS ICT helpdesk](mailto:helpdesk@bas.ac.uk)
if you don't have this access.

Note: This volume has a permissions policy to allow anonymous read on all directories and files.

vApp files should be stored using the following directory structure:

```shell
$ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vapps/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]
```

OVA files should then be stored using the following file name structure:

```shell
$ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vapps/[Template distribution name]/[Template distribution version]/[Template architecture]/[Artefact version]/[Provider]-vapp.ovf.zip [Provider]-vapp.ovf.zip
```

E.g.

```shell
$ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vapps/ubuntu/14.04/amd64/0.0.0
$ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vapps/ubuntu/14.04/amd64/0.0.0/vmware-vapp.ovf.zip artefacts/ovas/antarctica-trusty-vmware-iso/vmware-vmware.ovf.zip
```

#### vDirector

vApps produces by this project can be imported into a catalogue in vDirector to act as templates for new vApps.
I.e. A base vApp which mirrors the base VMs or images used by other providers.

The vApp OVF file will need to uploaded to vDirector using the on-line interface.

Note: These instructions are tested with the vDirector installation used by the JASMIN un-managed cloud only. If you 
are using installation of vDirector these steps may not work.

Note: You must use Internet Explorer 11 in order to install the required browser plugins to upload files.

Note: In future it is hoped an automated deployment method can be used to uploading the relevant OVF file.

1. Download the relevant zipped vApp and uncompress to a local directory
2. Login to the vDirector web interface and from the dashboard choose *Catalogues*
3. Select the *BAS-Base-Images* Catalogue
4. Choose the *vApps Templates* tab and then *upload*
5. Choose *Upload* and select the OVF file uncompressed in step 1 and choose upload [1]
    * Set the name to `[Template distribution name]-vdirector-[Template version]` (e.g. `antarctica/trusty-director-0.0.0`)
    * Set to the description to [2]
6. Once uploaded, select the template and choose *properties*:
    * Set meta-data key-values to [3]

[1] Though only the OVF file is selected, related files such as the virtual hard disk will be uploaded as well.

[2]
vDirector compatible version of the '`[Template distribution name]`' base image using a single VM wrapped in a vApp.
More information: https://github.com/antarctica/packer-vm-templates

E.g.
vDirector compatible version of the 'antarctica/trusty' base image using a single VM wrapped in a vApp.
More information: https://github.com/antarctica/packer-vm-templates

[3]

| Type | Name                  | Value                             | Value (example)     | Notes |
| ---- | --------------------- | --------------------------------- | ------------------- | ----- |
| Text | version               | `[Template version]`              | 0.0.0               | -     |
| Text | x-associated-template | `[Template distribution name]`    | `antarctica/trusty` | -     |
| Text | x-associated-version  | `[Template distribution version]` | 0.0.0               | -     |

## Acknowledgements

Other than the changes listed in the *Operating system customisations* section, and an altered directory structure,
these templates are the same as those found in the [Bento](https://github.com/opscode/bento) project from Chef.

Therefore 90% of any credit for this project should rightfully go to Bento. The authors of this project are incredibly
grateful for their work.

See their original notice file, `BENTO-NOTICE.md`, for further licensing information.

## Contributing

This project welcomes contributions, see `CONTRIBUTING` for our general policy.

## Feedback

Please log all feedback to the BAS Web and Applications Team:

* If you are a BAS/NERC staff member please use our [Jira project](https://jira.ceh.ac.uk/browse/BASWEB) with the
*Project - Packer* component.
* If you are external to BAS/NERC please email [basweb@bas.ac.uk](mailto:basweb@bas.ac.uk) to log feedback directly.

## Developing

### Project management

The Project Maintainer for this project is: [Felix Fennell](mailto:felnne@bas.ac.uk) [1].

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

Issues, bugs, improvements, questions, suggestions and other tasks related to this project are managed through our
[Jira project](https://jira.ceh.ac.uk/browse/BASWEB) using the *Project - Packer* component [2].

[1] Please use the contact information in the *Feedback* section, rather than direct contact.

[2] Please use the contact information in the *Feedback* section to request new accounts [BAS/NERC Staff only].

### License

Copyright 2015 NERC BAS. Licensed under the Apache License for compatibility with Bento, see `LICENSE.md` for details.
