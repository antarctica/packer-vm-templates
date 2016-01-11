#!/usr/bin/env bash -eux
# This script is only needed for cloud images as on desktops the kick-start process will configure the locale

sudo localectl set-locale LANG=en_GB.UTF-8;
