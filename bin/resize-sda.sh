#!/bin/sh

sudo growpart /dev/sda 3 && sudo resize2fs /dev/sda3
