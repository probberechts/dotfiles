# shellcheck shell=bash
# shell/interactive.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.sh {"
[ -f "${HOME}/.local/dotfiles.lock" ] &&
  "${DOTFILES}/shell/dko-wait-for-dotfiles-lock"

# need this here in case not starting a login shell
. "${DOTFILES}/lib/helpers.sh"

. "${DOTFILES}/shell/functions.sh" # shell functions

case "$DOTFILES_OS" in
  Darwin) . "${DOTFILES}/shell/interactive-darwin.zsh" ;;
  Linux)
    . "${DOTFILES}/shell/interactive-linux.sh"
    ;;
esac

# ==============================================================================
# env management -- Node, Python, Ruby - These add to path
# These may rely on things installed by brew so move after interactive-darwin
# ==============================================================================

. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/haskell.sh"
. "${DOTFILES}/shell/rust.sh"

# source aliases late so command -v (as in __dko_has) doesn't detect them

. "${DOTFILES}/shell/aliases.sh" # generic aliases

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
