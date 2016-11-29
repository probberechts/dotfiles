#!/usr/bin/env bash
#
# Tap and install caskroom apps
#

set -eu

brew tap caskroom/cask
brew tap caskroom/versions

brew update

brew cask install android-file-transfer
brew cask install dropbox
brew cask install google-chrome
brew cask install iterm2
brew cask install transmission
brew cask install cyberduck
brew cask install vlc
brew cask install xquartz
brew cask install selfcontrol
brew cask install flux
brew cask install xld
brew cask install gimp
brew cask instal spotify

brew cask install karabiner-elements
brew cask install hammerspoon
