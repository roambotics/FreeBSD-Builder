#!/bin/sh

. ./variables.sh

main () {
  for param in "$@" ; do
    case "$param" in
      0|prep)
        prep
        ;;
      -v=*|--value=*)
        VALUE="${i#*=}"
        ;;
      -f|--flag)
        FLAG=1
        ;;
      hello)
        hello
        ;;
      --)
        break
        ;;
      *)
        usage
        ;;
    esac
  done
}

usage () {
  echo "Usage: ..."
}

prep () {
  update_all
  reboot_single_user
}

hello () {
  echo "Hello, world!"
}

update_freebsd_source () {
  echo 'Updating FreeBSD source code...'
  $SVN up $FREEBSD_SRC_DIR
  echo 'Updating FreeBSD source code... Done.'
}

update_doc_source () {
  echo 'Updating documentation source...'
  $SVN up $DOC_SRC_DIR
  echo 'Updating documentation source... Done.'
}

update_ports () {
  echo 'Updating ports...'
  $SVN up $PORTS_SRC_DIR
  portmaster --no-confirm -m BATCH=yes -aD
  #portmaster --no-confirm -m BATCH=yes -m DISABLE_VULNERABILITIES=yes -aD
  portsclean -CD
  echo 'Updating ports... Done.'
}

update_all () {
  update_freebsd_source
  update_doc_source
  update_ports
}

reboot_single_user () {
  echo 'Rebooting into single user mode...'
  nextboot -D
  nextboot -o "-s" -k kernel
  shutdown -r +1
  echo 'Rebooting into single user mode... Done.'
}

main $@

