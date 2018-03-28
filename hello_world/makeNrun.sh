#!/bin/bash

clear
echo "This script includes commands to make the project and run it"

echo "clean up the directory with make clean"
make clean
echo "make the project with make."
make
echo "Guiding mtools mcopy to its configuration file"
export MTOOLSRC=mtools.conf
echo "Copying the binary to floppy image"
mcopy embedded.bin a:
echo "Starting Qemu with given binary in the floppy image"
qemu-system-i386 -fda floppy.img

