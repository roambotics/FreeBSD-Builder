#!/bin/sh

echo 'Rebuilding ports...'
svn up /usr/ports
portmaster --no-confirm -m BATCH=yes -afD
portsclean -CD
echo 'Rebuilding ports... Done.'

echo 'Deleting obsolete libraries...'
sh -c 'cd /usr/src && make delete-old-libs'
sh -c 'cd /usr/src && make -DWITH_ATF delete-old-libs'
echo 'Deleting obsolete libraries... Done.'

