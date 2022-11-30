# shell/path.sh
#
# Sourced in bash and zsh by loader
# pyenv, chruby, chphp, nvm pathing is done in shell/after
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/path.sh"

# ==============================================================================
# Store default system path
# ==============================================================================

# Probably created via /etc/profile and /etc/profile.d/*
#
# On macOS/OS X/BSD path_helper is run in /etc/profile, which generates paths
# using /etc/paths and /etc/paths.d/* and defines the initial $PATH
# Something like "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
#
# On arch, via /etc/profile, default path is:
# /usr/local/sbin:/usr/local/bin:/usr/bin
if [ -n "$DKO_SYSTEM_PATH" ]; then
  export DKO_SYSTEM_PATH="${PATH}:${DKO_SYSTEM_PATH}"
else
  export DKO_SYSTEM_PATH="${PATH}"
fi

# _add_my_paths
#
dko::add_paths() {
  # Begin my_path composition --------------------------------------------------
  # On BSD system, e.g. Darwin -- path_helper is called, reads /etc/paths
  # Move local bin to front for homebrew compatibility
  #if [ -x /usr/libexec/path_helper ]; then
  my_path="$DKO_SYSTEM_PATH"

  # enforce local bin and sbin order
  my_path="/usr/local/bin:/usr/local/sbin:${DKO_SYSTEM_PATH}"

  # local ----------------------------------------------------------------------

  my_path="${DOTFILES}/bin:${my_path}"

  [ ! -d "${HOME}/.local/bin" ] && mkdir -p "${HOME}/.local/bin"
  my_path="${HOME}/.local/bin:${my_path}"

  echo "${my_path}"
}

PATH="$(dko::add_paths)"


# ==============================================================================
# Anyenv
# ==============================================================================

export ANYENV_ROOT="${HOME}/.anyenv"
export PATH="${ANYENV_ROOT}/bin:${PATH}"
[ -d "${ANYENV_ROOT}" ] && eval "$(anyenv init --no-rehash - $SHELL)"

# ==============================================================================
# direnv
# ==============================================================================

[ -x "$(command -v direnv)" ] && eval "$(direnv hook $SHELL)"

export PATH

# vim: ft=sh :
