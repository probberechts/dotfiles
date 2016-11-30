#!/usr/bin/env bash
#
# Copy compiled terminfo files
#

# errors are okay.
#set -eu

# ============================================================================
# initialize script and dependencies
# ============================================================================

cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
source "${dotfiles_path}/shell/helpers.sh"

# ==============================================================================
# Main
# ==============================================================================

dko::status "Copying terminfo files"

# Install all uncompiled terminfo files, e.g.
# - xterm-256color-italic for iterm2
# - tmux-256color for tmux
find "${dotfiles_path}/terminfo/" -name '*.terminfo' -exec tic -x {} \;
