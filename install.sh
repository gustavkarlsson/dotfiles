#!/bin/bash

THIS_FILE_NAME=`basename "$0"`                        # script file name
THIS_DIR=`readlink -f ${0%/*}`                        # script directory, where your dotfiles will be symlinked
BACKUP_DIR="${HOME}/dotfiles_backup/`date -Iseconds`" # old dotfiles backup directory
FILES=`ls $THIS_DIR -I $THIS_FILE_NAME | tr "\n" " "` # list of files/folders to symlink in homedir

echo "Dotfiles detected: $FILES"

echo "Creating backup directory: $BACKUP_DIR"
mkdir -p $BACKUP_DIR

echo "Backing up existing dotfiles from $HOME"
for FILE in $FILES; do
    mv -f ${HOME}/.${FILE} $BACKUP_DIR
done

echo "Creating symlinks in $HOME to files in $THIS_DIR"
for FILE in $FILES; do
    ln -s ${THIS_DIR}/${FILE} ${HOME}/.${FILE}
done

echo "Done!"

