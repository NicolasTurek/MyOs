#!/bin/sh
nasm bootloader.asm -f bin -o bootloader.bin
dd if=bootloader.bin bs=512 of=fd0.img
