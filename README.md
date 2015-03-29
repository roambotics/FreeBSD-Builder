# FreeBSD-Bootstrap #

Staged scripts to build FreeBSD wrapped up into one executable file (builder.sh).
Also contains random utility scripts because I wanted to put everything in one place.

## Working With GitHub Keys ##

```sh
  sh # if the below does not work, you are using the wrong shell
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
```

