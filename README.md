# dotfiles 🦆

These are my dotfiles. There is a python script that installs and backs up everything.
Installation and backup steps work well, the rest is... eeeeh, it's a cruel world. They would "work" on Fedora+GNOME.

```
$ ./install.py
usage: install.py [-h] [-d] [-b] [-r] [-i] [-p] [-P]

options:
  -h, --help          show this help message and exit
  -d, --dry-run       Perform dry-run
  -D, --diff          Diff dotfiles and exit
  -r, --requirements  Run requirement step
  -p, --pre           Run pre-install step
  -i, --install       Run install step
  -P, --post          Run post-install step
  -b, --backup        Backs up files
  -q, --quiet         Run with no output
  -v, --verbose       Verbose mode (logger DEBUG)

```

You can try the command using `-d` to perform a dry run

If you run with `-b` option all the others are ignored except for `-d` (the script will NOT complain about it).

You can run parts of the script individually. For example, if you already have all the dependencies installed you could just run
```
./install.py -piP
```

or
```
./install.py --pre --install --post
```
and just do the rest.

Cool!

