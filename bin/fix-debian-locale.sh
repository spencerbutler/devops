#!/bin/sh

MY_LOCALE="en_US.UTF-8 UTF-8"
LOCALE_FILE=/etc/locale.gen

# uncomment our prefered locale
sudo sed -i".bak" -e "s/# \(${MY_LOCALE}\)/\1/" $LOCALE_FILE

# regenerate the locales
sudo locale-gen

# show the new locales
locale -a
