# FreeBSD-Bootstrap #

Staged scripts to build FreeBSD wrapped up into one executable file (builder.sh).
Also contains random utility scripts because I wanted to put everything in one place.

## Initial Machine Bootstrapping ##
```sh
  su
  sh
  svnlite co svn://svn.freebsd.org/ports/head /usr/ports
  cd /usr/ports/ports-mgmt/portmaster && make config-recursive && make config-recursive && make install clean
  portmaster ports-mgmt/portupgrade devel/git editors/vim
  git clone git@github.com:Sennue/FreeBSD-Bootstrap.git builder
  cd ~/builder
  cp HOSTNAME_KERNEL.example HOSTNAME_KERNEL # use actual hostname
  vim HOSTNAME_KERNEL # configure file
  cp secure_variables.sh.example secure_variables.sh
  vim secure_variables.sh # configure file
  ~/builder/builder.sh bootstrap bootstrap_rc
  vim /etc/rc.conf # double check nothing is silly
  shutdown -r now

  # rebuild the system a couple of times to smooth out the wrinkles compiling from source
  # ideally repeat until a hot install completes the first try without any errors
  su
  sh
  ~/builder/builder.sh hot_install
  # fix errors and try the above again, if there are no errors
  shutdown -r now
```

## Working With GitHub Keys ##

```sh
  # create ssh key, if need be
  # Reference: https://help.github.com/articles/generating-ssh-keys/
  ssh-keygen -t rsa -C "your_email@example.com"

  # add ssh key to session using the sh shell
  sh
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
```

