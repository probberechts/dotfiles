# shell/aliases
# Not run by loader
# Sourced by both .zshrc and .bashrc, so keep it bash compatible

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases.sh"

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"
alias dirs="dirs -v" # default to vert, use -l for list
alias tree="tree -C"

# cat
alias pyg="pygmentize -O style=rrt -f console256 -g"

# shorter git
# alias g='git'

# Open file in existing MacVim window
alias gvim="open -a MacVim"
alias mvim="open -a MacVim"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias showdotfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidedotfiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias showdeskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedeskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

# Start/Stop postgres server
alias pg_start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pg_stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

# Count words in Latex doc
alias countTex="clear;texcount -total -q -col -sum *.tex"

# bin
alias grep="grep --color=auto"
alias ag="ag --hidden --smart-case --one-device --path-to-ignore \"\${DOTFILES}/ag/dot.ignore\""
alias today="date +%d-%m-%Y"
alias catn="cat -n" # Concatenate and print content of files (add line numbers)

# python
alias pea="pyenv activate"
alias ped="pyenv deactivate"
alias py2="python2"
alias py3="python3"
alias py="python"

# sudo ops
alias mine="sudo chown -R \"\$USER\""
alias root="sudo -s"
alias se="sudo -e"

# editor
alias ehosts='se /etc/hosts'
alias essh='e "${HOME}/.ssh/config"'
alias etmux='e "${DOTFILES}/tmux/tmux.conf"'
alias eze='e "${ZDOTDIR}/dot.zshenv"'
alias ezi='e "${ZDOTDIR}/zinit.zsh"'
alias ezl='e "${LDOTDIR}/zshrc"'
alias ezr='e "${ZDOTDIR}/.zshrc"'
alias ke="pkill -f 'nvim.sock'"

# direnv
alias tmux='direnv exec / tmux'

# ============================================================================

__alias_ls() {
  local almost_all="-A" # switchted from --almost-all for old bash support
  local classify="-F"   # switched from --classify for old bash support
  local colorized="--color=auto"
  local groupdirs="--group-directories-first"
  local literal=""
  local long="-l"
  local single_column="-1"
  local timestyle=""

  if ! ls $groupdirs >/dev/null 2>&1; then
    groupdirs=""
  fi

  if [ "$DOTFILES_OS" = "Darwin" ]; then
    almost_all="-A"
    classify="-F"
    colorized="-G"
  fi

  if [ "$DOTFILES_OS" = "Linux" ] && [ "$DOTFILES_DISTRO" != "busybox" ]; then
    literal="-N"
    timestyle="--time-style=\"+%Y%m%d\""
  fi

  # shellcheck disable=SC2139
  alias ls="ls $colorized $literal $classify $groupdirs $timestyle"
  # shellcheck disable=SC2139
  alias la="ls $almost_all"
  # shellcheck disable=SC2139
  alias l="ls $single_column $almost_all"
  # shellcheck disable=SC2139
  alias ll="l $long"
}
__alias_ls

# ============================================================================

__alias_darwin() {
  alias b="TERM=xterm-256color brew"
  alias brew="TERM=xterm-256color brew"

  alias bi="b install"
  alias bq="b list"
  alias bs="b search"

  alias bsvc="b services"
  alias bsvr="b services restart"

  # sudo since we run nginx on port 80 so needs admin
  alias rnginx="sudo brew services restart nginx"

  # electron apps can't focus if started using Electron symlink
  alias elec="/Applications/Electron.app/Contents/MacOS/Electron"

  # clear xattrs
  alias xc="xattr -c *"

  # Audio control - http://xkcd.com/530/
  alias stfu="osascript -e 'set volume output muted true'"
}

# ============================================================================

__alias_linux() {
  alias open="o" # use open() function in shell/functions
}

# ============================================================================

__alias_arch() {
  if command -v pacaur >/dev/null; then
    alias b="pacaur"
  elif command -v yaourt >/dev/null; then
    alias b="yaourt"
  fi
  alias bi="b -S"
  alias bq="b -Qs"
  alias bs="b -Ss"
}

# ============================================================================

__alias_deb() {
  alias b="sudo apt "
}

# ============================================================================

# os specific
case "$OSTYPE" in
  darwin*) __alias_darwin ;;
  linux*)
    __alias_linux
    case "$DOTFILES_DISTRO" in
      busybox) ;;
      archlinux) __alias_arch ;;
      debian) __alias_deb ;;
    esac
    ;;
esac

# vim: ft=sh :
