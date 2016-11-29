# zsh/keybindings.zsh
#
# These keys should also be set in shell/.inputrc
#
# `cat -e` to test out keys
#
# \e is the same as ^[ is the escape code for <Esc>
# Prefer ^[ since it mixes better with the letter form [A
#

export DKO_SOURCE="${DKO_SOURCE} -> keybindings.zsh"

# disable ^S and ^Q terminal freezing
unsetopt flowcontrol

# VI mode
bindkey -v

# map jj to Esc
bindkey -M viins 'jj' vi-cmd-mode

# make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# Left and right should jump through words
# C-Left
bindkey '^[[1;5D' backward-word
# C-Right
bindkey '^[[1;5C' forward-word

# Up and down search history filtered using already entered contents
# C-Up
bindkey '^[[1;5A'  history-search-backward
# C-Down
bindkey '^[[1;5B'  history-search-forward
