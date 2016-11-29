#!/usr/bin/env bash

set -eu

# taps -------------------------------------------------------------------------
brew tap homebrew/dupes
brew tap homebrew/emacs

# brew services launchctl manager -- no formulae 
brew tap homebrew/services

# meta -------------------------------------------------------------------------
brew update
brew install homebrew/completions/brew-cask-completion

# install tapped formulae ------------------------------------------------------
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

# compilers, tools, and libs ---------------------------------------------------
brew install automake cmake
brew install coreutils findutils

# general ----------------------------------------------------------------------
brew install aspell

# filesystem -------------------------------------------------------------------
brew install ack
brew install tree
brew install gawk
brew install fzf

# operations -------------------------------------------------------------------
brew install nmap
brew install ssh-copy-id
brew install multitail

# pretty print and processor ---------------------------------------------------
brew install icdiff

# programming ------------------------------------------------------------------
brew install cloc
brew install tidy-html5

# shells -----------------------------------------------------------------------
brew install bash bash-completion
brew install tmux
brew install zsh

# vcs --------------------------------------------------------------------------
# git completions provided by zsh
brew install git
brew install git-extras hub

# web --------------------------------------------------------------------------
brew install curl wget
brew install heroku-toolbelt
brew install node

# links to /Applications -------------------------------------------------------
brew linkapps
