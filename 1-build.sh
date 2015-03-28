#!/bin/sh

KERNEL_CONFIG=`hostname | tr '[:lower:]' '[:upper:]'`_KERNEL
KERNEL_CONFIG=SPECTRE_KERNEL

echo 'Mounting RW filesystem...'
#fsck -p
mount -u /
mount -a -t ufs 
swapon -a
echo 'Mounting RW filesystem... Done.'

echo 'Adjusting clock...'
adjkerntz -i
echo 'Adjusting clock... Done.'

echo 'Building FreeBSD documentation...'
#sh -c 'cd /usr/doc && make install clean'
sh -c 'cd /usr/doc/en_US.ISO8859-1 && make install clean'
sh -c 'cd /usr/doc/ja_JP.eucJP && make install clean'
echo 'Building FreeBSD documentation... Done.'

echo 'Cleaning FreeBSD build environment...'
chflags -R noschg /usr/obj/*
rm -rf /usr/obj/*
sh -c 'cd /usr/src && make cleandir && make cleandir'
echo 'Cleaning FreeBSD build environment... Done.'

echo 'Building FreeBSD world...'
sh -c 'cd /usr/src && make buildworld'
echo 'Building FreeBSD world... Done.'

echo 'Backing up kernel...'
sh -c 'cd /boot/ && cp -Rp kernel kernel.good'
echo 'Backing up kernel... Done.'

echo 'Building and Installing FreeBSD kernel...'
#sh -c "cd /usr/src && make buildkernel KERNCONF=$KERNEL_CONFIG"
#sh -c "cd /usr/src && make installkernel KERNCONF=$KERNEL_CONFIG"
sh -c "cd /usr/src && make kernel KERNCONF=$KERNEL_CONFIG"
echo 'Building and Installing FreeBSD kernel... Done.'

echo 'Rebooting into single user mode...'
nextboot -D
nextboot -o "-s" -k kernel
shutdown -r +1
echo 'Rebooting into single user mode... Done.'

