# shellcheck shell=bash
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

# https://pip.pypa.io/en/stable/topics/configuration/#pip-config-file
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"

__dko_has "pip" && {
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(python3 -m pip completion --zsh)"
  elif [ -n "$BASH" ]; then
    eval "$(python3 -m pip completion --bash)"
  fi
}

# ==============================================================================
# jupyter
# ==============================================================================

alias jl='jupyter lab'
alias jk-list='jupyter kernelspec list'
alias jk-rm='jupyter kernelspec uninstall'

jk-install() {
    local NAME="${1:-${PWD}}"

    if ! python -c "import ipykernel" &> /dev/null; then
        echo "Error: ipykernel not found in this environment."
        echo "Run 'pip install ipykernel' first."
        return 1
    fi

    python -m ipykernel install --user --display-name "$NAME" --name "${PWD##*/}"
    echo "Successfully installed kernel: $NAME"
}

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"

# vim: ft=sh :
