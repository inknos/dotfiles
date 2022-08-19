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
            "for i in {1..9}; do gsettings set org.gnome.shell.keybindings switch-to-application-$i \"['']\"; done",
            "gsettings set org.gnome.desktop.interface font-name 'DejaVu Sans 11'",
            "gsettings set org.gnome.desktop.wm.preferences titlebar-font 'DejaVu Sans Bold 11'",
            "gsettings set org.gnome.desktop.interface document-font-name 'DejaVu Sans Semi-Condensed 11'",
            "gsettings set org.gnome.desktop.interface monospace-font-name 'DejaVu SansMono 10'"
        ],
        "dotfiles" : [],
        "post-install" : []
    },

}

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

class DotfileInstaller:
    def __init__(self, dictionary, dry_run = False):
        # create logger
        self._logger = logging.getLogger("dotfiles")
        self._logger.setLevel(logging.DEBUG)

        # create console handler with a higher log level
        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)

        ch.setFormatter(CustomFormatter())

        self._logger.addHandler(ch)

        self._dry_run = dry_run
        if self._dry_run:
            self._logger.info("Dry run")

        self._dictionary = dictionary

    @property
    def logger(self):
        return self._logger


    def _file_exists(self, file):
        """
        Return True if file exists
        False if doesn't and log it.
        """
        if not os.path.exists(file):
            self._logger.warning("{} does not exist".format(file))
            return False
        return True

    def _install_dotfile(self, dotfile):
        source = os.path.join(dotfiles, dotfile)
        dest = os.path.join(home, dotfile)
        if not self._file_exists(source):
            return
        self._logger.info("Copying {} into {}".format(source, dest))
        if not self._dry_run:
            shutil.copy(source, dest)

    def _backup_dotfile(self, dotfile):
        source = os.path.join(home, dotfile)
        dest = os.path.join(dotfiles, dotfile)
        if not self._file_exists(source):
            self._logger.warning("File {} does not exist. Cannot Backup.".format(source))
            return
        self._logger.info("Copying {} into {}".format(source, dest))
        if not self._dry_run:
            shutil.copy(source, dest)

    def _run_command(self, command):
        self._logger.info(command)
        if not self._dry_run:
            subprocess.run(command, shell=True)

    def _install_all_dotfiles(self):
        self._logger.info("Installing dotfiles...")
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["dotfiles"]:
                self._install_dotfile(dotfile)

    def _backup_all_dotfiles(self):
        self._logger.info("Backing up dotfiles...")
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["dotfiles"]:
                self._backup_dotfile(dotfile)

    def _run_all_pre_install(self):
        self._logger.info("Run pre-install scripts...")
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["pre-install"]:
                self._run_command(dotfile)

    def _run_all_post_install(self):
        self._logger.info("Run post-install scripts...")
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["post-install"]:
                self._run_command(dotfile)

    def _install_all_requirements(self):
        self._logger.info("Install requirements...")
        if self._dry_run:
            return
        requirements = []
        for item in self._dictionary:
            for req in files[item]["requirements"]:
                requirements.append(req)
        self._run_command("sudo dnf install " +  " ".join(requirements), self._dry_run)

    def requirements(self):
        self._install_all_requirements()

    def pre(self):
        self._run_all_pre_install()

    def install(self):
        self._install_all_dotfiles()

    def post(self):
        self._run_all_post_install()


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

    dots = DotfileInstaller(files, args.dry_run)

    if args.backup:
        dots.backup()
    elif all(v is None for v in [ args.requirements, args.install, args.pre_install, args.post_install ]):
        dots.requirements()
        dots.pre()
        dots.install()
        dots.post()
    else:
        if args.requirements:
            dots.requirements()
        if args.pre_install:
            dots.pre()
        if args.install:
            dots.install()
        if args.post_install:
            dots.post()

if __name__ == "__main__":
    main()
