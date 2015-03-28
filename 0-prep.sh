#!/bin/sh

echo 'Updating FreeBSD source code...'
svn up /usr/src
echo 'Updating FreeBSD source code... Done.'

echo 'Updating documentation source...'
svn up /usr/doc
echo 'Updating documentation source... Done.'

echo 'Updating ports...'
svn up /usr/ports
portmaster --no-confirm -m BATCH=yes -aD
#portmaster --no-confirm -m BATCH=yes -m DISABLE_VULNERABILITIES=yes -aD
portsclean -CD
echo 'Updating ports... Done.'

echo 'Rebooting into single user mode...'
nextboot -D
nextboot -o "-s" -k kernel
shutdown -r +1
echo 'Rebooting into single user mode... Done.'

