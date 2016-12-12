#!/usr/bin/env bash
#
# Basic symlinks, safe to run on any system
#

set -e

# ============================================================================
# initialize script and dependencies
# ============================================================================

cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
source "${dotfiles_path}/shell/helpers.sh"

# ============================================================================
# Main
# ============================================================================


__symlink() {
  dko::status "Symlinking dotfiles"

  # ctags
  dko::symlink ctags/dot.ctags                      .ctags

  # XDG-compatible
  dko::symlink git/dot.gitconfig                    .config/git/config
  dko::symlink git/dot.gitignore                    .config/git/ignore
  dko::symlink shell/dot.inputrc                    .config/readline/inputrc

  # (n)vim
  dko::symlink vim                                  .vim
  dko::symlink vim                                  .config/nvim

  #tmux
  dko::symlink tmux/tmux.conf                       .tmux.conf

  #ssh
  dko::symlink ssh                                  .ssh

  #keyboard
  dko::symlink keyboard/hammerspoon.lua             .hammerspoon/init.lua

   # symlink shells ---------------------------------------------------------------
  dko::symlink bash/dot.bashrc                      .bashrc
  dko::symlink bash/dot.bash_profile                .bash_profile
  dko::symlink zsh/dot.zshenv                       .zshenv

  dko::status "Done! [symlink.sh]"
}

__symlink
