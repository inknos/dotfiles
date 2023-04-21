#!/usr/bin/env python

import argparse
import difflib
import logging
import filecmp
import os
import shutil
import subprocess
import sys
import yaml


working_dir = os.getcwd()
dotfiles = os.path.join(working_dir, 'dotfiles')
home = os.path.expanduser('~')

grey_cc = "\x1b[38;20m"
yellow_cc = "\x1b[33;20m"
red_cc = "\x1b[31;20m"
bold_red_cc = "\x1b[31;1m"
green_cc = "\x1b[32;20m"
bold_green_cc = "\x1b[32;1m"
reset_cc = "\x1b[0m"

EXIT_CODE_SUCCESS = 0
EXIT_CODE_NOT_IN_SYNC = 10
EXIT_CODE_LOCAL_NOT_IN_SYNC = 12
EXIT_CODE_BACKUP_NOT_IN_SYNC = 14

class CustomFormatter(logging.Formatter):
    grey = grey_cc
    yellow = yellow_cc
    red = red_cc
    bold_red = bold_red_cc
    reset = reset_cc
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


def _H(path):
    p = path
    p = p.replace("/home/nsella", "~")
    p = p.replace("$HOME", "~")
    return p

class DotfileInstaller:
    """
    Manage dictionary to install dotfiles.

    For each package it can install requirements,
    run pre/post-install scripts, copy dotfiles
    and backup them.
    """

    class YamlLoader():
        def __init__(self, yaml=os.path.join(working_dir, "packages.yaml")):
            self._yaml = yaml
            self._db = {}
            self.load()

        def load(self):
            with open(self._yaml, 'r') as stream:
                try:
                    self._db=yaml.safe_load(stream)
                except yaml.YAMLError as exc:
                    print(exc)

        @property
        def db(self):
            return self._db

        @property
        def yaml(self):
            return self._yaml

        @yaml.setter
        def yaml(self, var):
            self._yaml = var
            self._file_exists(self._yaml)

    def __init__(self, dry_run=False, pkglist=[], loglevel=logging.INFO):
        self._yl = self.YamlLoader()

        self._dictionary = self._yl.db
        self._pkglist = pkglist

        # create logger
        self._logger = logging.getLogger("dotfiles")
        self._logger.setLevel(loglevel)

        # create console handler with a higher log level
        ch = logging.StreamHandler()

        ch.setFormatter(CustomFormatter())
        self._logger.addHandler(ch)

        self._dry_run = dry_run
        if self._dry_run:
            self._logger.info("Run in dry-run mode")

        if self._pkglist != []:
            self._dictionary = {k:v for k,v in self._dictionary.items() if k in self._pkglist}

        self._exit = EXIT_CODE_SUCCESS

    @property
    def exit(self):
        return self._exit

    @property
    def logger(self):
        return self._logger

    @property
    def pkglist(self):
        return self._pkglist

    @pkglist.setter
    def pkglist(self, arg):
        self._pkglist = arg

    def _local_file_is_newer(self, file):
        """
        Retun True if local dotfile is newer
        """
        src = os.path.join(dotfiles, file)
        dst = os.path.join(home, file)
        if not self._file_exists(src):
            return True
        if not self._file_exists(dst):
            return False
        src_t = os.path.getmtime(src)
        dst_t = os.path.getmtime(dst)
        return src_t < dst_t

    def _file_exists(self, file):
        """
        Return True if file exists
        False if doesn't and log it.
        """
        if not os.path.exists(file):
            self._logger.warning("{} does not exist".format(_H(file)))
            return False
        return True

    def _files_are_the_same(self, dotfile):
        """
        Return False if file differ or one file does not exist
        """
        src = os.path.join(home, dotfile)
        dst = os.path.join(dotfiles, dotfile)
        try:
            result = filecmp.cmp(src, dst)
        except FileNotFoundError:
            result = False
        return result

    def _install_dotfile(self, dotfile):
        """
        Install dotfile from dotfile dir to $HOME
        """
        src = os.path.join(dotfiles, dotfile)
        dst = os.path.join(home, dotfile)
        if not self._file_exists(src):
            return
        if self._files_are_the_same(dotfile):
            self._logger.debug("DUPLICATE: {} was not copied".format(_H(dotfile)))
            return
        self._logger.info("CP {} -> {}".format(_H(src), _H(dst)))
        if not self._dry_run:
            shutil.copy(src, dst)

    def _backup_dotfile(self, dotfile):
        """
        Backup dotfile from $HOME to dotfile dir
        """
        src = os.path.join(home, dotfile)
        dst = os.path.join(dotfiles, dotfile)
        if not self._file_exists(src):
            return
        if self._files_are_the_same(dotfile):
            self._logger.debug("DUPLICATE: {} was not copied".format(_H(dotfile)))
            return
        self._logger.info("CP {} -> {}".format(_H(src), _H(dst)))
        if not self._dry_run:
            shutil.copy(src, dst)

    def _diff_dotfiles(self, dotfile):
        """
        Diff dotfiles
        """
        src = os.path.join(home, dotfile)
        dst = os.path.join(dotfiles, dotfile)
        if not self._file_exists(src):
            return
        if self._files_are_the_same(dotfile):
            return
        self._logger.debug("DIFF {}".format(dotfile))
        with open(src) as file_1:
            file_1_text = file_1.readlines()
        with open(dst) as file_2:
            file_2_text = file_2.readlines()
        for line in difflib.unified_diff(
                file_1_text, file_2_text, fromfile=src,
                tofile=dst):
            if line[:3] == "---":
                print()
                print(bold_red_cc + line + reset_cc, end="")
            elif line[:3] == "+++":
                print(bold_green_cc + line + reset_cc, end="")
            elif line[:2] == "@@" and line[-3:-1] == "@@":
                print(yellow_cc + line + reset_cc, end="")
            elif line[0] == "+" and line[0] != "+++":
                print(green_cc + line + reset_cc, end="")
            elif line[0] == "-" and line[:3] != "---":
                print(red_cc + line + reset_cc, end="")
            else:
                print(line, end="")


    def _run_command(self, command):
        """
        Run bash command from python
        Log in DEBUG stdout and stderr
        """
        self._logger.debug("RUN: {}".format(command))
        if not self._dry_run:
            with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True) as p:
                for line in p.stdout:
                    self._logger.debug(line)
                for line in p.stderr:
                    self._logger.error(line)

    def _install_all_dotfiles(self):
        """
        Loop through dotfiles and install them
        """
        self._logger.info("Install dotfiles...")
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["dotfiles"]:
                self._install_dotfile(dotfile)

    def _backup_all_dotfiles(self):
        """
        Loop through dotfiles and backup them
        """
        self._logger.info("Backup dotfiles...")
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["dotfiles"]:
                self._backup_dotfile(dotfile)

    def _run_all_pre_install(self):
        """
        Loop through pre install scripts and run them
        """
        self._logger.info("Run pre-install scripts...")
        for item in self._dictionary:
            for command in self._dictionary[item]["pre-install"]:
                self._run_command(command)

    def _run_all_post_install(self):
        """
        Loop through post install scripts and run them
        """
        self._logger.info("Run post-install scripts...")
        for item in self._dictionary:
            if item not in self._pkglist:
                continue
            for command in self._dictionary[item]["post-install"]:
                self._run_command(command)

    def _install_all_requirements(self):
        """
        Loop through requirements and install them
        """
        self._logger.info("Install requirements...")
        if self._dry_run:
            return
        requirements = []
        for item in self._dictionary:
            for req in self._dictionary[item]["requirements"]:
                requirements.append(req)
        if requirements == []:
            self._logger.info("Requirements list is empty")
        self._logger.debug("Requirements list:", requirements)
        self._run_command("sudo dnf5 install -y " + " ".join(requirements))

    def _check_all_files(self):
        """
        Check all file dates and return the correct exit code
        """
        exit_code_local_not_in_sync_t = False
        exit_code_backup_not_in_sync_t = False
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["dotfiles"]:
                if self._files_are_the_same(dotfile):
                    continue
                if self._local_file_is_newer(dotfile):
                    self._logger.debug("Local version of {} is newer".format(dotfile))
                    exit_code_local_not_in_sync_t = True
                else:
                    self._logger.debug("Backup version of {} is newer".format(dotfile))
                    exit_code_backup_not_in_sync_t = True
        if exit_code_local_not_in_sync_t and exit_code_backup_not_in_sync_t:
            self._exit = EXIT_CODE_NOT_IN_SYNC
        elif exit_code_local_not_in_sync_t:
            self._exit = EXIT_CODE_LOCAL_NOT_IN_SYNC
        elif exit_code_backup_not_in_sync_t:
            self._exit = EXIT_CODE_BACKUP_NOT_IN_SYNC

    def _diff_all_dotfiles(self):
        """
        Loop through dotfiles and diff them
        """
        for item in self._dictionary:
            for dotfile in self._dictionary[item]["dotfiles"]:
                self._diff_dotfiles(dotfile)

    def requirements(self):
        """
        Install all requirements
        """
        self._install_all_requirements()

    def pre(self):
        """
        Run pre-install scripts
        """
        self._run_all_pre_install()

    def install(self):
        """
        Install dotfiles
        """
        self._install_all_dotfiles()

    def post(self):
        """
        Run post-install scripts
        """
        self._run_all_post_install()

    def backup(self):
        """
        Backup dotfiles
        """
        self._backup_all_dotfiles()

    def check(self):
        """
        Check if files need to be updated
        return 10 if local files are out of date
        return 12 if backup files are out of date
        """
        self._check_all_files()

    def diff(self):
        self._diff_all_dotfiles()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--check',
                        action='store_true',
                        dest='check',
                        help='Check if dotfiles need to be updated'
                        )
    parser.add_argument('-d', '--dry-run',
                        action='store_true',
                        dest='dry_run',
                        help='Perform dry-run'
                        )
    parser.add_argument('-D', '--diff',
                        action='store_true',
                        dest='diff',
                        help='Diff dotfiles and exit'
                        )
    parser.add_argument('-r', '--requirements',
                        action='store_true',
                        dest='requirements',
                        help='Run requirement step'
                        )
    parser.add_argument('-p', '--pre',
                        action='store_true',
                        dest='pre_install',
                        help='Run pre-install step'
                        )
    parser.add_argument('-i', '--install',
                        action='store_true',
                        dest='install',
                        help='Run install step'
                        )
    parser.add_argument('-P', '--post',
                        action='store_true',
                        dest='post_install',
                        help='Run post-install step'
                        )
    parser.add_argument('-b', '--backup',
                        action='store_true',
                        dest='backup',
                        help='Backs up files'
                        )
    verbosity_group = parser.add_mutually_exclusive_group()

    verbosity_group.add_argument('-q', '--quiet',
                        action='store_true',
                        dest='quiet',
                        help='Run with no output'
                        )
    verbosity_group.add_argument('-v', '--verbose',
                        action='store_true',
                        dest='verbose',
                        help='Verbose mode (logger DEBUG)'
                        )
    parser.add_argument('pkglist', nargs='*',
                        help='List of packages to process'
                        )
    args = parser.parse_args()

    if args.verbose:
        loglevel = logging.DEBUG
    elif args.quiet:
        loglevel =logging.WARNING
    else:
        loglevel = logging.INFO

    dots = DotfileInstaller(
        dry_run=args.dry_run,
        pkglist=args.pkglist,
        loglevel=loglevel
    )

    if args.backup:
        dots.backup()
    elif args.check:
        dots.check()
    elif args.diff:
        dots.diff()
    elif all(v is False for v in [args.requirements, args.install, args.pre_install, args.post_install]):
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

    exit(dots.exit)

if __name__ == "__main__":
    main()
