# dotfiles

These are my dotfiles. There is a python script that installs and backs up everything.

```
$ ./install.py
usage: install.py [-h] [-d] [-b] [-r] [-i] [-p] [-P]

options:
  -h, --help          show this help message and exit
  -d, --dry-run       Perform dry-run
  -b, --backup        Backs up files
  -r, --requirements  Run requirement step
  -i, --install       Run install step
  -p, --pre           Run pre-install step
  -P, --post          Run post-install step
```

You can try the command using `-d` to performa dry run

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


