#!/usr/bin/env bash -e

# Colours for output formatting
FGYellow='\e[33m'
FGGreen='\e[32m'
FGBlue='\e[34m'
FGRed='\e[31m'
FGreset='\e[39m'

# Confirmation check function - exists script if answered in the negative
confirm () {
    # call with a prompt string or use a default
    read -r -p "? > Are you ready? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            exit 1
            ;;
    esac
}

# Introduction
printf "\n"
printf "${FGBlue}BAS Packer VM Templates - Standard build script${FGreset}\n"
printf "\n"
printf "  This script will:\n"
printf "  * Check you have required software on your local machine\n"
printf "  * Clean up any previous built artefacts\n"
printf "  * Build VM templates using Packer\n"
printf "  * Package artefacts for distribution\n"
printf "  * Generate checksums for use in artefact lists\n"
printf "  * Release artefacts to AWS S3 and the BAS SAN"
printf "\n"
printf "  Notes:\n"
printf "  * This script *is not* intended to a robust or flexible solution - it is an aid only\n"
printf "  * This script *is* intended as a stepping stone for using CI/CD for building these templates in the future\n"
printf "\n"
printf "  Requirements:\n"
printf "  * A private key, '~/.ssh/id_rsa', with the associated public key authorised to login to 'bslcene'\n"
printf "  * An environment variable, 'AWS_ACCESS_KEY_ID' set for an AWS IAM user with access to BAS AWS S3 buckets\n"
printf "  * An environment variable, 'AWS_ACCESS_KEY_SECRET' set fr an AWS IAM user with access to BAS AWS S3 buckets\n"
printf "\n"
printf "${FGYellow}  If you have not used this script before you *MUST* read the project README first!${FGreset} \n"

# Systems check
printf "\n"
printf "${FGBlue}== Systems check${FGreset}\n"

printf "\n"
if command -v packer >/dev/null 2>&1; then
    printf "${FGGreen}<>${FGreset} 'packer' command found\n"
else
    { printf >&2 "${FGRed}><${FGreset} 'packer' command not found - aborting!\n"; exit 1; }
fi
if command -v ovftool >/dev/null 2>&1; then
    printf "${FGGreen}<>${FGreset} 'ovftool' command found\n"
else
    { printf >&2 "${FGRed}><${FGreset} 'ovftool' command not found - aborting!\n"; exit 1; }
fi
if command -v tar >/dev/null 2>&1; then
    printf "${FGGreen}<>${FGreset} 'tar' command found\n"
else
    { printf >&2 "${FGRed}><${FGreset} 'tar' command not found - aborting!\n"; exit 1; }
fi
if command -v openssl >/dev/null 2>&1; then
    printf "${FGGreen}<>${FGreset} 'openssl' command found\n"
else
    { printf >&2 "${FGRed}><${FGreset} 'openssl' command not found - aborting!\n"; exit 1; }
fi

printf "\n"
printf "${FGGreen}All Systems Go!${FGreset}\n"

# Clean up
printf "\n"
printf "${FGBlue}== Cleaning up old artefacts${FGreset}\n"
printf "\n"

find artefacts/ovas -mindepth 1 -delete
printf "${FGGreen}<>${FGreset} OVA files cleaned\n"

find artefacts/vagrant-base-boxes/base-boxes -mindepth 1 -delete
printf "${FGGreen}<>${FGreset} Vagrant base boxes cleaned\n"

printf "\n"
printf "${FGGreen}# All Clean${FGreset}\n"

# Build!
printf "\n"
printf "${FGBlue}== Building artefacts${FGreset}\n"
printf "\n"

printf " Template versions are needed for building, you will need to workout the new version of each template:\n"
printf "\n"
read -r -p "? > Version for the antarctica/trusty template (e.g. 1.2.3) " VAR_antarctica_trusty_version
read -r -p "? > Version for the antarctica/centos7 template (e.g. 1.2.3) " VAR_antarctica_centos7_version

printf "\n"
printf "  This script will now call packer to build *ALL* VM templates - specifically it will call:\n"
printf "  $ packer build -var 'release_version=${VAR_antarctica_trusty_version}' templates/antarctica-trusty-desktop.json\n"
printf "  $ packer build -var 'release_version=${VAR_antarctica_trusty_version}' templates/antarctica-trusty-cloud.json\n"
printf "  $ packer build -var 'release_version=${VAR_antarctica_centos7_version}' templates/antarctica-centos7-desktop.json\n"
printf "  $ packer build -var 'release_version=${VAR_antarctica_centos7_version}' templates/antarctica-centos7-cloud.json\n"

printf "\n"
printf "${FGYellow}For safety, you need to confirm this action${FGreset}\n"
confirm

printf "\n  Sit tight this will take a while - Packer's output will follow...\n"

printf "\n"
printf "  Processing the 'antarctica/trusty' (desktop) template:\n"
packer build -var "release_version=${VAR_antarctica_trusty_version}" templates/antarctica-trusty-desktop.json
printf "\n"
printf "${FGGreen}<>${FGreset} 'antarctica/trusty' (desktop) built successfully\n"

printf "\n"
printf "  Processing the 'antarctica/trusty' (cloud) template:\n"
packer build -var "release_version=${VAR_antarctica_trusty_version}" templates/antarctica-trusty-cloud.json
printf "\n"
printf "${FGGreen}<>${FGreset} 'antarctica/trusty' (cloud) built successfully\n"

printf "\n"
printf "  Processing the 'antarctica/centos7' (desktop) template:\n"
packer build  -var "release_version=${VAR_antarctica_centos7_version}" templates/antarctica-centos7-desktop.json
printf "\n"
printf "${FGGreen}<>${FGreset} 'antarctica/centos7' (desktop) built successfully\n"

printf "\n"
printf "  Processing the 'antarctica/centos7' (cloud) template:\n"
packer build -var "release_version=${VAR_antarctica_centos7_version}" templates/antarctica-centos7-cloud.json
printf "\n"
printf "${FGGreen}<>${FGreset} 'antarctica/centos7' (cloud) built successfully\n"

printf "\n"
printf "${FGGreen}Builds Complete${FGreset}\n"

# Sort out VMware
printf "\n"
printf "${FGBlue}== Packaging artefacts${FGreset}\n"

printf "\n"
printf "  VMware VMX files need to be re-packaged into OVA files using 'ovftool' - which this role will do for you\n"
printf "  For each template you will see two sets of output:\n"
printf "  1. Converting the VMX to a OVF file\n"
printf "  2. Verifying the OVA file (which has since been generated from the OVF file) is valid\n"

printf "\n"
printf "  Processing the 'antarctica/trusty' template:\n"
mkdir -p artefacts/ovas/antarctica-trusty-vmware-iso/scratch
ovftool artefacts/ovas/antarctica-trusty-vmware-iso/vmware.vmx artefacts/ovas/antarctica-trusty-vmware-iso/scratch/vmware.ovf
cd artefacts/ovas/antarctica-trusty-vmware-iso/scratch
tar cf ../vmware.ova vmware.ovf vmware.mf vmware-disk1.vmdk
cd ..
rm -rf scratch
ovftool --schemaValidate vmware.ova
printf "\n"
printf "${FGGreen}<>${FGreset} 'antarctica/trusty' converted successfully\n"

# # Reset working path
cd ../../../

printf "\n"
printf "  Processing the 'antarctica/centos7' template:\n"
mkdir -p artefacts/ovas/antarctica-centos7-vmware-iso/scratch
ovftool artefacts/ovas/antarctica-centos7-vmware-iso/vmware.vmx artefacts/ovas/antarctica-centos7-vmware-iso/scratch/vmware.ovf
cd artefacts/ovas/antarctica-centos7-vmware-iso/scratch
tar cf ../vmware.ova vmware.ovf vmware.mf vmware-disk1.vmdk
cd ..
rm -rf scratch
ovftool --schemaValidate vmware.ova
printf "\n"
printf "${FGGreen}<>${FGreset} 'antarctica/centos7' converted successfully\n"

# # Reset working path
cd ../../../

printf "\n"
printf "${FGGreen}Packaging Complete${FGreset}\n"

printf "\n"
printf "${FGBlue}== Generate artefact checksums${FGreset}\n"

printf "\n"
openssl sha1 artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box
openssl sha1 artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/virtualbox.box
openssl sha1 artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/vmware.box
openssl sha1 artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/virtualbox.box

printf "\n"
printf "${FGGreen}Checksums Complete${FGreset}\n"

printf "\n"
printf "${FGBlue}== Releasing artefacts${FGreset}\n"

printf "\n"
printf "  This script will now call (cyber)duck to distribute artefacts to the BAS SAN and AWS S3 for release - specifically it will call:\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/virtualbox.box\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.ova artefacts/ovas/antarctica-trusty-vmware-iso/vmware.ova\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.ova artefacts/ovas/antarctica-trusty-virtualbox-iso/virtualbox.ova\n"
printf "\n"
printf "  $ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/\n"
printf "  $ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/virtualbox.box\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.ova artefacts/ovas/antarctica-trusty-vmware-iso/vmware.ova\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.ova artefacts/ovas/antarctica-trusty-virtualbox-iso/virtualbox.ova\n"
printf "\n"
printf "\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/vmware.box\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/virtualbox.box\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.ova artefacts/ovas/antarctica-centos7-vmware-iso/vmware.ova\n"
printf "  $ duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.ova artefacts/ovas/antarctica-centos7-virtualbox-iso/virtualbox.ova\n"
printf "\n"
printf "  $ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/\n"
printf "  $ ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/vmware.box\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/virtualbox.box\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.ova artefacts/ovas/antarctica-centos7-vmware-iso/vmware.ova\n"
printf "  $ duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.ova artefacts/ovas/antarctica-centos7-virtualbox-iso/virtualbox.ova\n"

printf "\n"
printf "${FGYellow}For safety, you need to confirm this action${FGreset}\n"
confirm

printf "\n"
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/virtualbox.box
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.ova artefacts/ovas/antarctica-trusty-vmware-iso/vmware.ova
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.ova artefacts/ovas/antarctica-trusty-virtualbox-iso/virtualbox.ova
printf "${FGGreen}<>${FGreset} 'antarctica/trusty' artefacts copied to AWS S3 successfully\n"

printf "\n"
ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/
ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/vmware.box
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-trusty/virtualbox.box
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/vmware.ova artefacts/ovas/antarctica-trusty-vmware-iso/vmware.ova
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/ubuntu/14.04/amd64/${VAR_antarctica_trusty_version}/virtualbox.ova artefacts/ovas/antarctica-trusty-virtualbox-iso/virtualbox.ova
printf "${FGGreen}<>${FGreset} 'antarctica/trusty' artefacts copied to BAS SAN successfully\n"


printf "\n"
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/vmware.box
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/virtualbox.box
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.ova artefacts/ovas/antarctica-centos7-vmware-iso/vmware.ova
duck --username $AWS_ACCESS_KEY_ID --password $AWS_ACCESS_KEY_SECRET --region eu-west-1 --upload s3://bas-packages-prod/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.ova artefacts/ovas/antarctica-centos7-virtualbox-iso/virtualbox.ova
printf "${FGGreen}<>${FGreset} 'antarctica/centos7' artefacts copied to AWS S3 successfully\n"

printf "\n"
ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/
ssh bslcene.nerc-bas.ac.uk mkdir -p /data/softwaredist/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/vmware.box
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/vagrant/baseboxes/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.box artefacts/vagrant-base-boxes/base-boxes/antarctica-centos7/virtualbox.box
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/vmware.ova artefacts/ovas/antarctica-centos7-vmware-iso/vmware.ova
duck --username $(whoami) --identity ~/.ssh/id_rsa --upload sftp://bslcene.nerc-bas.ac.uk/data/softwaredist/ovas/centos/7.2/x86_64/${VAR_antarctica_centos7_version}/virtualbox.ova artefacts/ovas/antarctica-centos7-virtualbox-iso/virtualbox.ova
printf "${FGGreen}<>${FGreset} 'antarctica/centos7' artefacts copied to BAS SAN successfully\n"

printf "\n"
printf "${FGGreen}Release Complete${FGreset}\n"

# Fin
printf "\n"
printf "${FGGreen}Standard Build Complete${FGreset}\n"
printf "\n"
printf "  You will need to manually upload and publish the artefact list for base boxes using the computed SHA1 hashes\n"
printf "  You will also need to manually update the Terraform remote state for cloud images and push this state back up\n"
printf "\n"
