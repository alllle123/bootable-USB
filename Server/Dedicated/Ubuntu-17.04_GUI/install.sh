#!/bin/bash

sudo umount $2
sudo dd bs=4M if=$1 of=$2
