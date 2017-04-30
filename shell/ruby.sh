# shell/ruby.sh
#
# Uses vars from shell/vars and shell/os
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/ruby.sh {"

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export DKO_SOURCE="${DKO_SOURCE} }"
