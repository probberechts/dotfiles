# shell/vars.sh
#
# Some things from env are here since macOS/OS X doesn't start new env for each
# term and we may need to reset the values
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/vars.sh {"

# dot.bash_profile did this early
# @TODO maybe dot.bash_profile needs to skip init
DOTFILES_OS="${DOTFILES_OS:-$(uname)}"
export DOTFILES_OS

case "$DOTFILES_OS" in
  Darwin*)
    # disable Terminal.app session saving in /etc/zshrc_Apple_Terminal
    export SHELL_SESSIONS_DISABLE=1
    # distro is arm64 or x86_64
    export DOTFILES_DISTRO="${DOTFILES_DISTRO:-$(uname -m)}"
    ;;
  FreeBSD*) export DOTFILES_DISTRO="FreeBSD" ;;
  OpenBSD*) export DOTFILES_DISTRO="OpenBSD" ;;

  *)
    # for pacdiff
    export DIFFPROG="nvim -d"

    # X11 - for starting via xinit or startx
    export XAPPLRESDIR="${DOTFILES}/linux"

    if [ -f /etc/arch-release ]; then
      # manjaro too
      export DOTFILES_DISTRO="archlinux"
    elif [ -f /etc/debian_version ]; then
      export DOTFILES_DISTRO="debian"
    elif [ -f /etc/fedora-release ]; then
      export DOTFILES_DISTRO="fedora"
    fi
    ;;
esac

# ============================================================================
# Locale
# ============================================================================

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ============================================================================
# Dotfile paths
# ============================================================================

export DOTFILES="${HOME}/.dotfiles"
export BDOTDIR="${DOTFILES}/bash"
export LDOTDIR="${DOTFILES}/local"
export ZDOTDIR="${DOTFILES}/zsh"

# ============================================================================
# XDG
# ============================================================================

export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# user-dirs.dirs doesn't exist on macOS/OS X so check first.
# Exporting is fine since the file is generated via xdg-user-dirs-update
# and should have those vars. I am just using the defaults but want them
# explicitly defined.
# shellcheck source=/dev/null
[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ] &&
  . "${XDG_CONFIG_HOME}/user-dirs.dirs" &&
  export \
    XDG_DESKTOP_DIR \
    XDG_DOWNLOAD_DIR \
    XDG_TEMPLATES_DIR \
    XDG_PUBLICSHARE_DIR \
    XDG_DOCUMENTS_DIR \
    XDG_MUSIC_DIR \
    XDG_PICTURES_DIR \
    XDG_VIDEOS_DIR &&
  DKO_SOURCE="${DKO_SOURCE} -> ${XDG_CONFIG_HOME}/user-dirs.dirs"

[ -z "$XDG_DOWNLOAD_DIR" ] && [ -d "${HOME}/Downloads" ] &&
  export XDG_DOWNLOAD_DIR="${HOME}/Downloads"

# ============================================================================
# History -- except HISTFILE location is set by shell rc file
# ============================================================================

export HISTSIZE=50000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTIGNORE="ll:ls:cd:cd -:pwd:exit:date:* --help"

# ============================================================================
# program settings
# ============================================================================

# ----------------------------------------------------------------------------
# for rsync and cvs
# ----------------------------------------------------------------------------

export CVSIGNORE="${DOTFILES}/git/.gitignore"

# ----------------------------------------------------------------------------
# editor
# ----------------------------------------------------------------------------

export EDITOR='e'
export VISUAL="$EDITOR"

export GIT_EDITOR="giteditor"

# create-react-app
export REACT_EDITOR="$VISUAL"

# this requires Defaults env_keep += "SYSTEMD_EDITOR" in your sudo settings to
# take effect. See https://unix.stackexchange.com/a/408419
export SYSTEMD_EDITOR="$EDITOR"

# ----------------------------------------------------------------------------
# pager
# ----------------------------------------------------------------------------

export PAGER="less"
export GIT_PAGER="$PAGER"

# ----------------------------------------------------------------------------
# others
# ----------------------------------------------------------------------------

# aws
export AWS_CONFIG_FILE="${DOTFILES}/aws/config"
# credentials are per system

# gpg
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"

# less
# -F quit if one screen (default)
# -N line numbers
# -R raw control chars (default)
# -X don't clear screen on quit
# -e LESS option to quit at EOF
export LESS="-eFRX"
# disable less history
export LESSHISTFILE=-

# man
export MANWIDTH=88
export MANPAGER="$PAGER"

# neovim
export NVIM_PYTHON_LOG_FILE="${DOTFILES}/logs/nvim_python.log"
export VDOTDIR="${XDG_CONFIG_HOME}/nvim"

# R
export R_ENVIRON_USER="${DOTFILES}/r/.Renviron"
export R_LIBS_USER="${HOME}/.local/lib/R/library/"

# readline
export INPUTRC="${DOTFILES}/shell/dot.inputrc"

# ruby moved to shell/ruby loaded in shell/before

# for shellcheck
export SHELLCHECK_OPTS="--exclude=SC1090,SC2148"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
