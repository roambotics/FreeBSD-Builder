#!/bin/sh

. ./variables.sh

echo 'Updating FreeBSD source code...'
$SVN up $FREEBSD_SRC_DIR
echo 'Updating FreeBSD source code... Done.'

echo 'Updating documentation source...'
$SVN up $DOC_SRC_DIR
echo 'Updating documentation source... Done.'

echo 'Updating ports...'
$SVN up $PORTS_SRC_DIR
portmaster --no-confirm -m BATCH=yes -aD
#portmaster --no-confirm -m BATCH=yes -m DISABLE_VULNERABILITIES=yes -aD
portsclean -CD
echo 'Updating ports... Done.'

echo 'Rebooting into single user mode...'
nextboot -D
nextboot -o "-s" -k kernel
shutdown -r +1
echo 'Rebooting into single user mode... Done.'

