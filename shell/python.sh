# shell/python.sh
#
# uses vars from shell/vars and functions from shell/functions
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/python.sh"

# Let python guess where to `import` packages, or use pip instead
unset PYTHONPATH

# ==============================================================================
# Pylint
# ==============================================================================

export PYLINTHOME="${XDG_CONFIG_HOME}/pylint"
export PYLINTRC="${DOTFILES}/python/pylintrc"

# ==============================================================================
# pyenv for multiple Python binaries
# ==============================================================================

dko::has "pyenv-virtualenv-init" && eval "$(pyenv virtualenv-init -)"

# ==============================================================================
# VirtualEnv for python package isolation
# ==============================================================================

# Disable auto-add virtualenv name to prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Assign global var to virtualenv name
virtualenv_info() {
  venv=''
  # Strip out the path and just leave the env name
  [ -n "$VIRTUAL_ENV" ] && venv="${VIRTUAL_ENV##*/}"
  [ -n "$venv" ] && printf '%s\n' "$venv"
}

# ==============================================================================
# pip
# ==============================================================================

dko::has "pip" && {
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(python3 -m pip completion --zsh)"
  elif [ -n "$BASH" ]; then
    eval "$(python3 -m pip completion --bash)"
  fi
}

# vim: ft=sh :
