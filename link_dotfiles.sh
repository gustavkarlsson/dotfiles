#!/bin/bash

BACKUP_DIR="${HOME}/dotfiles_backup/`date -Iseconds`" # old dotfiles backup directory
THIS_DIR=`readlink -f ${0%/*}`                        # script directory, where your dotfiles will be symlinked
DOTFILES_DIR_NAME="files"                             # name of the directory where the actual dotfiles are located
DOTFILES_DIR="${THIS_DIR}/${DOTFILES_DIR_NAME}"       #
DOTFILES=`ls "$DOTFILES_DIR" | tr "\n" " "`           # list of files/folders to symlink in homedir

echo "Dotfiles found: $DOTFILES"

echo "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "Backing up existing dotfiles from $HOME"
for FILE in $DOTFILES; do
    mv -f "${HOME}/.${FILE}" "$BACKUP_DIR"
done

echo "Creating symlinks in $HOME to files in $DOTFILES_DIR"
for FILE in $DOTFILES; do
    ln -s "${DOTFILES_DIR}/${FILE}" "${HOME}/.${FILE}"
done

echo "Done!"

