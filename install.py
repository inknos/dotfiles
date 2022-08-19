#!/bin/python3

import argparse
import logging
import os
import shutil
import subprocess
import sys


working_dir = os.getcwd()
dotfiles = os.path.join(working_dir, 'dotfiles')
home = os.path.expanduser('~')


class CustomFormatter(logging.Formatter):
    grey = "\x1b[38;20m"
    yellow = "\x1b[33;20m"
    red = "\x1b[31;20m"
    bold_red = "\x1b[31;1m"
    reset = "\x1b[0m"
    # format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)"
    format = "%(levelname)s: %(message)s"

    FORMATS = {
        logging.DEBUG: grey + format + reset,
        logging.INFO: grey + format + reset,
        logging.WARNING: yellow + format + reset,
        logging.ERROR: red + format + reset,
        logging.CRITICAL: bold_red + format + reset
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)

# create logger with 'spam_application'
logger = logging.getLogger("dotfiles")
logger.setLevel(logging.DEBUG)

# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

ch.setFormatter(CustomFormatter())

logger.addHandler(ch)

files = {
    "local-bin" : {
        "requirements" : [],
        "pre-install" : [
            "mkdir -p $HOME/.local/bin"
        ],
        "dotfiles" : [
            ".local/bin/dbox-remote"
        ],
        "post-install" : []
    },
    "joplin" : {
        "requirements" : [
            "dejavu-fonts-all"
        ],
        "pre-install" : [],
        "dotfiles" : [
            ".config/joplin-desktop/userchrome.css",
            ".config/joplin-desktop/userstyle.css"
        ],
        "post-install" : []
    },
    "vim" : {
        "requirements" : [
            "vim-enhanced",
            "cmake",
            "curl",
            "gcc-c++",
            "go",
            "npm",
            "python-devel",
            "dejavu-fonts-all"
        ],
        "pre-install" : [
            "curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
	        "mkdir -p $HOME/.cache/vim/{swp,bkp}"
            ],
        "dotfiles" : [ ".vimrc" ],
        "post-install" : [
	        "vim -c 'PlugInstall' -c 'qa!'",
            "/usr/bin/python3 $HOME/.vim/plugged/YouCompleteMe/install.py --all"
        ]
    },
    "tmux" : {
        "requirements" : [ "tmux" ],
        "pre-install" : [
            "git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"
        ],
        "dotfiles" : [ ".tmux.conf", ".tmux.bashrc" ],
        "post-install" : [ "tmux source-file $HOME/.tmux.conf" ]
    },
    "git" : {
        "requirements" : [],
        "pre-install" : [],
        "dotfiles" : [ ".gitignore.global", ".gitconfig"],
        "post-install" : []
    },
    "oh-my-bash" : {
        "requirements" : [],
        "pre-install" : [
            "bash -c \"$(curl -fsSL \
            https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)\"",
            "mkdir -p $HOME/.oh-my-bash/themes/producktive{,-root}"],
        "dotfiles" : [
            ".bashrc",
            ".aliases",
            ".environment",
            ".oh-my-bash/themes/producktive/producktive.theme.sh",
            ".oh-my-bash/themes/producktive-root/producktive-root.theme.sh"],
        "post-install" : [ ]
    },
    "gnome-terminal" : {
        "requirements" : [],
        "pre-install" : [ "dconf load /org/gnome/terminal/legacy/profiles:/ < dotfiles/gnome-terminal-profiles.dconf" ],
        "dotfiles" : [],
        "post-install" : []
    },
    "gnome-shell" : {
        "requirements" : [],
        "pre-install" : [
            "for i in {1..9}; do gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i \"['<Super>$i']\"; done",
            "for i in {1..9}; do gsettings set org.gnome.shell.keybindings switch-to-application-$i \"['']\"; done"
        ],
        "dotfiles" : [],
        "post-install" : []
    },

}

def file_exists(file):
    if not os.path.exists(file):
        logger.warning("{} does not exist".format(file))
        return False
    return True

def install_dotfile(dotfile, dry_run=False):
    source = os.path.join(dotfiles, dotfile)
    dest = os.path.join(home, dotfile)
    if not file_exists(source):
        return
    logger.info("Copying {} into {}".format(source, dest))
    if not dry_run:
        shutil.copy(source, dest)

def backup_dotfile(dotfile, dry_run=False):
    source = os.path.join(home, dotfile)
    dest = os.path.join(dotfiles, dotfile)
    if not file_exists(source):
        logger.warning("File {} does not exist. Cannot Backup.".format(source))
        return
    logger.info("Copying {} into {}".format(source, dest))
    if not dry_run:
        shutil.copy(source, dest)

def run_command(command, dry_run=False):
    logger.info(command)
    if not dry_run:
        subprocess.run(command, shell=True)

def install_all_dotfiles(dictionary, dry_run=False):
    logger.info("Installing dotfiles...")
    for item in dictionary:
        for dotfile in dictionary[item]["dotfiles"]:
            install_dotfile(dotfile, dry_run)

def backup_all_dotfiles(dictionary, dry_run=False):
    logger.info("Backing up dotfiles...")
    for item in dictionary:
        for dotfile in dictionary[item]["dotfiles"]:
            backup_dotfile(dotfile, dry_run)

def run_all_pre_install(dictionary, dry_run=False):
    logger.info("Run pre-install scripts...")
    for item in dictionary:
        for dotfile in dictionary[item]["pre-install"]:
            run_command(dotfile, dry_run)

def run_all_post_install(dictionary, dry_run=False):
    logger.info("Run post-install scripts...")
    for item in dictionary:
        for dotfile in dictionary[item]["post-install"]:
            run_command(dotfile, dry_run)

def install_requirements(dictionary, dry_run=False):
    logger.info("Install requirements...")
    if dry_run:
        return
    requirements = []
    for item in dictionary:
        for req in files[item]["requirements"]:
            requirements.append(req)
    run_command("sudo dnf install " +  " ".join(requirements), dry_run)

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--dry-run',
                    action='store_true',
                    dest='dry_run',
                    help='Perform dry-run'
                    )
    parser.add_argument('-b', '--backup',
                    action='store_true',
                    dest='backup',
                    help='Backs up files'
                    )
    parser.add_argument('-r', '--requirements',
                    action='store_true',
                    dest='requirements',
                    help='Run requirement step'
                    )
    parser.add_argument('-i', '--install',
                    action='store_true',
                    dest='install',
                    help='Run install step'
                    )
    parser.add_argument('-p', '--pre',
                    action='store_true',
                    dest='pre_install',
                    help='Run pre-install step'
                    )
    parser.add_argument('-P', '--post',
                    action='store_true',
                    dest='post_install',
                    help='Run post-install step'
                    )
    args = parser.parse_args()

    dry_run = args.dry_run
    if dry_run:
        logger.info("Dry run")
    if args.backup:
        backup_all_dotfiles(files)
    elif all(v is None for v in [ args.requirements, args.install, args.pre_install, args.post_install]):
        install_requirements(files, dry_run)
        run_all_pre_install(files, dry_run)
        install_all_dotfiles(files, dry_run)
        run_all_post_install(files, dry_run)
    else:
        if args.requirements:
            install_requirements(files, dry_run)
        if args.pre_install:
            run_all_pre_install(files, dry_run)
        if args.install:
            install_all_dotfiles(files, dry_run)
        if args.post_install:
            run_all_post_install(files, dry_run)

if __name__ == "__main__":
    main()
