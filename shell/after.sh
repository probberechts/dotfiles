# shell/after.sh
#
# Runs before local/* .zshrc and .bashrc
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ==============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ==============================================================================

dko::has "nvim" && {
  export EDITOR="nvim"
  export VISUAL="nvim"
}

# ==============================================================================
# Auto-manpath
# ==============================================================================

unset MANPATH

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh :
