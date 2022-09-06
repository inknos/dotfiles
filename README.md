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


#### I run Cron with this script (I am lazy)

```
* */2 * * * nsella nice -n 19 /home/nsella/Documents/personal_projects/dotfiles/cron.sh; EXIT_STATUS=$?; if [ $EXIT_STATUS -ne 0 ]; then notify-send -i warning -t 0 "Hey, dotfiles should be backed up." --icon=dialog-information ; fi
```


