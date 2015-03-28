#!/bin/sh

echo 'Adjusting clock...'
adjkerntz -i
echo 'Adjusting clock... Done.'

echo 'Updating FreeBSD source code...'
svn up /usr/src
echo 'Updating FreeBSD source code... Done.'

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
sh -c "cd /usr/src && make kernel KERNCONF=$KERNEL_CONFIG"
echo 'Building and Installing FreeBSD kernel... Done.'

echo 'Running preinstall mergemaster...'
mergemaster -p
echo 'Running preinstall mergemaster... Done.'

echo 'Installing FreeBSD world...'
sh -c 'cd /usr/src && make installworld'
echo 'Installing FreeBSD world... Done.'

echo 'Running postinstall mergemaster...'
mergemaster
echo 'Running postinstall mergemaster... Done.'

echo 'Deleting obsolete files and directories...'
sh -c 'cd /usr/src && make check-old'
sh -c 'cd /usr/src && make -DBATCH_DELETE_OLD_FILES delete-old'
sh -c 'cd /usr/src && make -DWITH_ATF delete-old'
echo 'Deleting obsolete files and directories... Done.'

echo 'Deleting obsolete libraries...'
sh -c 'cd /usr/src && make delete-old-libs'
sh -c 'cd /usr/src && make -DWITH_ATF delete-old-libs'
echo 'Deleting obsolete libraries... Done.'

