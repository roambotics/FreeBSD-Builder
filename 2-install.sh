#!/bin/sh

echo 'Mounting RW filesystem...'
#fsck -p
mount -u /
mount -a -t ufs
swapon -a
echo 'Mounting RW filesystem... Done.'

echo 'Adjusting clock...'
adjkerntz -i
echo 'Adjusting clock... Done.'

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

echo 'Rebooting system...'
shutdown -r +1
echo 'Rebooting system... Done.'

