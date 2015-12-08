#!/bin/sh -eux

# This file relies on environment variables to provide template information. Required variables are:
# * TEMPLATE_NAME      equal to the 'proper' name of the template (e.g. antarctica/trusty)
# * TEMPLATE_NAME_ALT  equal to the 'safe' name of the template   (e.g. antarctica-trusty)
# * TEMPLATE_VERSION   equal to the version of the template       (e.g. 3.1.0)

# Create local facts directory
mkdir -p /etc/ansible/facts.d

# Create fact file with template information
# Produces a file like:
# [general]
# name=antarctica/trusty
# name_alt=antarctica-trusty
# version=3.1.0
printf "[general]\nname=$TEMPLATE_NAME\nname_alt=$TEMPLATE_NAME_ALT\nversion=$TEMPLATE_VERSION\n" > /etc/ansible/facts.d/os_template.fact
