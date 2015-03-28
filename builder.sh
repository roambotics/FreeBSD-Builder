#!/bin/sh

. ./variables.sh

main () {
  for param in "$@" ; do
    case "$param" in
      0|prep)
        prep
        ;;
      1|build)
        build
        ;;
      2|install)
        install
        ;;
      3|postinstall)
        postinstall
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
  single_user_reboot
}

build () {
  single_user_bootstrap
  build_freebsd_all
  install_freebsd_kernel
  single_user_reboot
}

install () {
  single_user_bootstrap
  install_freebsd_world
  delete_obsolete_files
  muilti_user_reboot
}

postinstall () {
  rebuild_all_ports
  delete_obsolete_libraries
}

hello () {
  echo "Hello, world!"
}

update_all () {
  update_freebsd_source
  update_doc_source
  update_ports
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

rebuild_all_ports () {
  echo 'Rebuilding ports...'
  $SVN up $PORTS_SRC_DIR
  portmaster --no-confirm -m BATCH=yes -afD
  portsclean -CD
  echo 'Rebuilding ports... Done.'
}

multi_user_reboot() {
  echo 'Rebooting system...'
  shutdown -r +1
  echo 'Rebooting system... Done.'
}

single_user_reboot () {
  echo 'Rebooting into single user mode...'
  nextboot -D
  nextboot -o "-s" -k kernel
  shutdown -r +1
  echo 'Rebooting into single user mode... Done.'
}

single_user_bootstrap () {
  mount_rw_filesystem
  adjust_clock
}

mount_rw_filesystem () {
  echo 'Mounting RW filesystem...'
  #fsck -p
  mount -u /
  mount -a -t ufs 
  swapon -a
  echo 'Mounting RW filesystem... Done.'
}

adjust_clock () {
  echo 'Adjusting clock...'
  adjkerntz -i
  echo 'Adjusting clock... Done.'
}

build_freebsd_all () {
  build_freebsd_doc
  clean_build_environment
  build_freebsd_world
  backup_freebsd_kernel
  build_freebsd_kernel
}

clean_build_environment () {
  echo 'Cleaning FreeBSD build environment...'
  chflags -R noschg /usr/obj/*
  rm -rf /usr/obj/*
  (cd $FREEBSD_SRC_DIR; make cleandir && make cleandir)
  echo 'Cleaning FreeBSD build environment... Done.'
}

backup_freebsd_kernel () {
  echo 'Backing up kernel...'
  (cd /boot/; cp -Rp kernel kernel.good)
  echo 'Backing up kernel... Done.'
}

build_freebsd_doc () {
  echo 'Building FreeBSD documentation...'
  #(cd /usr/doc; make install clean)
  (cd $DOC_SRC_DIR/en_US.ISO8859-1; make install clean)
  (cd $DOC_SRC_DIR/ja_JP.eucJP; make install clean)
  echo 'Building FreeBSD documentation... Done.'
}

build_freebsd_world () {
  echo 'Building FreeBSD world...'
  (cd $FREEBSD_SRC_DIR; make buildworld)
  echo 'Building FreeBSD world... Done.'
}

build_freebsd_kernel () {
  echo 'Building FreeBSD kernel...'
  (cd $FREEBSD_SRC_DIR; make buildkernel KERNCONF=$KERNEL_CONFIG)
  echo 'Building FreeBSD kernel... Done.'
}

install_freebsd_kernel () {
  echo 'Installing FreeBSD kernel...'
  (cd $FREEBSD_SRC_DIR; make installkernel KERNCONF=$KERNEL_CONFIG)
  echo 'Installing FreeBSD kernel... Done.'
}

install_freebsd_world () {
  mergemaster_preinstall
  echo 'Installing FreeBSD world...'
  (cd $FREEBSD_SRC_DIR; make installworld)
  echo 'Installing FreeBSD world... Done.'
  mergemaster_postinstall
}

mergemaster_preinstall () {
  echo 'Running preinstall mergemaster...'
  mergemaster -p
  echo 'Running preinstall mergemaster... Done.'
}

mergemaster_postinstall () {
  echo 'Running postinstall mergemaster...'
  mergemaster
  echo 'Running postinstall mergemaster... Done.'
}

delete_obsolete_files () {
  echo 'Deleting obsolete files and directories...'
  (cd $FREEBSD_SRC_DIR; make check-old)
  (cd $FREEBSD_SRC_DIR; make -DBATCH_DELETE_OLD_FILES delete-old)
  (cd $FREEBSD_SRC_DIR; make -DWITH_ATF delete-old)
  echo 'Deleting obsolete files and directories... Done.'
}

delete_obsolete_libraries () {
  echo 'Deleting obsolete libraries...'
  (cd $FREEBSD_SRC_DIR; make delete-old-libs)
  (cd $FREEBSD_SRC_DIR; make -DWITH_ATF delete-old-libs)
  echo 'Deleting obsolete libraries... Done.'
}

main $@

