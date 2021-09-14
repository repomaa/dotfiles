#!/bin/sh

which nix 2>&1 > /dev/null && exit
sudo pacman -S nix
