#!/bin/python3

import dnf
import dnf.cli.progress

import libdnf
import os
import shutil
import subprocess
import sys


working_dir = os.getcwd()
dotfiles = os.path.join(working_dir, 'dotfiles')
home = os.path.expanduser('~')

files = {
    "vim" : {
        "requirements" : [
            "vim-enhanced",
            "cmake",
            "curl",
            "gcc-c++",
            "go",
            "npm",
            "python-devel"
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
        print("WARNING: {} does not exist".format(file))
        return False
    return True

def install_dotfile(dotfile, dry_run=False):
    source = os.path.join(dotfiles, dotfile)
    dest = os.path.join(home, dotfile)
    if not file_exists(source):
        return
    print("Copying {} into {}".format(source, dest))
    if not dry_run:
        shutil.copy(source, dest)

def backup_dotfile(dotfile, dry_run=False):
    source = os.path.join(home, dotfile)
    dest = os.path.join(dotfiles, dotfile)
    if not file_exists(source):
        return
    print("Copying {} into {}".format(source, dest))
    if not dry_run:
        shutil.copy(source, dest)

def run_command(command, dry_run=False):
    print(command)
    if not dry_run:
        subprocess.run(command, shell=True)

def install_all_dotfiles(dictionary, dry_run=False):
    print("Installing dotfiles...")
    for item in dictionary:
        for dotfile in dictionary[item]["dotfiles"]:
            install_dotfile(dotfile, dry_run)

def backup_all_dotfiles(dictionary, dry_run=False):
    print("Backing up dotfiles...")
    for item in dictionary:
        for dotfile in dictionary[item]["dotfiles"]:
            backup_dotfile(dotfile, dry_run)

def run_all_pre_install(dictionary, dry_run=False):
    print("Run pre-install scripts...")
    for item in dictionary:
        for dotfile in dictionary[item]["pre-install"]:
            run_command(dotfile, dry_run)

def run_all_post_install(dictionary, dry_run=False):
    print("Run post-install scripts...")
    for item in dictionary:
        for dotfile in dictionary[item]["post-install"]:
            run_command(dotfile, dry_run)

def install_requirements(dictionary, dry_run=False):
    print("Install requirements...")
    if dry_run:
        return
    requirements = []
    for item in dictionary:
        for req in files[item]["requirements"]:
            requirements.append(req)
    run_command("sudo dnf install " +  " ".join(requirements), dry_run)

def main():
    dry_run = False
    install_requirements(files, dry_run)
    run_all_pre_install(files, dry_run)
    install_all_dotfiles(files, dry_run)
    run_all_post_install(files, dry_run)

if __name__ == "__main__":
    main()
