#!/bin/bash

sudo woeusb iso/* $1 --device
sudo mount $1 ../usb
sudo mkdir ../usb/drivers
cp -r drivers/* ../usb/drivers
sudo umount ../usb
