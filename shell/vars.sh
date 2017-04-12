# shell/vars.sh
#
# Sourced by .zshenv or .bashrc
#
# Some things from env are here since macOS/OS X doesn't start new env for each
# term and we may need to reset the values
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/vars.sh {"

source "${HOME}/.dotfiles/shell/xdg.sh"

# ============================================================================
# Locale
# ============================================================================

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# ============================================================================
# Dotfile paths
# ============================================================================

export DOTFILES="${HOME}/.dotfiles"
export BASH_DOTFILES="${DOTFILES}/bash"
export VIM_DOTFILES="${DOTFILES}/vim"
export ZDOTDIR="${DOTFILES}/zsh"

# ============================================================================
# History -- except HISTFILE location is set by shell rc file
# ============================================================================

export SAVEHIST=1000
export HISTSIZE=1000
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoredups
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

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

EDITOR="$(command -v vim)"

# we have gvim, not in an SSH term, and the X11 display number is under 10
if command -v gvim >/dev/null 2>&1 \
&& [ "$SSH_TTY$DISPLAY" = "${DISPLAY#*:[1-9][0-9]}" ]; then
  export VISUAL="$(command -v gvim) -f"
  SUDO_EDITOR="$VISUAL"
else
  SUDO_EDITOR="$EDITOR"
fi

# ----------------------------------------------------------------------------
# pager
# ----------------------------------------------------------------------------

export PAGER="less"
export GIT_PAGER="$PAGER"

# ----------------------------------------------------------------------------
# others
# ----------------------------------------------------------------------------

# ack
export ACKRC="${DOTFILES}/ack/dot.ackrc"

# fzf
# ** is globbing completion in zsh, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"
# using git paths only for FZF
export FZF_DEFAULT_COMMAND='
  (git ls-tree -r --name-only HEAD ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'

# homebrew
export HOMEBREW_NO_ANALYTICS=1

# java settings - mostly for minecraft launcher
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.systemlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export JAVA_FONTS="/usr/share/fonts/TTF"

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

# mysql
export MYSQL_HISTFILE="${XDG_CACHE_HOME}/mysql_histfile"

# neovim
#export NVIM_PYTHON_LOG_FILE="${DOTFILES}/logs/nvim_python.log"

# python moved to shell/python loaded in shell/before

# R
export R_ENVIRON_USER="${DOTFILES}/r/.Renviron"
export R_LIBS_USER="${HOME}/.local/lib/R/library/"

# readline
export INPUTRC="${DOTFILES}/shell/dot.inputrc"

# ruby moved to shell/ruby loaded in shell/before

# for shellcheck
export SHELLCHECK_OPTS="--shell=bash --exclude=SC1090 --exclude=SC1091 --exclude=SC2148 --exclude=SC2039"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
