# Shell functions
# Sourced in bash and zsh by loader

export DKO_SOURCE="${DKO_SOURCE} -> shell/functions"

# ============================================================================
# Scripting
# ============================================================================

current_shell() {
  ps -p $$ | awk 'NR==2 { print $4 }'
}


# ============================================================================
# Dotfiles
# ============================================================================

# lookup dotfiles matching $1 and open in vim
dotf () {
    local PS3="Choose a file to edit: "
    select opt in \
      $(find ~/.dotfiles -type f -iname "*$1*" -not -path "*/vim/plugged/*" | sed -e "s/\/Users\/pieterrobberechts\/.dotfiles\///") \
      quit
    do
        if [[ $opt = "quit" ]]
        then
            break
        fi
        ${EDITOR:-nano} "$opt"
        break
    done
}

# open the dotfiles directory in the editor
dots () {
    e ~/.dotfiles
}

# ============================================================================
# SSH
# ============================================================================

# Copy over ssh-id (w/o dependencies)
authme() {
  ssh "$1" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
}

mykey() {
  cat "$HOME/.ssh/id_rsa.pub"
  if has_program "pbcopy"; then
    pbcopy < "$HOME/.ssh/id_rsa.pub"
  elif has_program "xclip"; then
    xclip "$HOME/.ssh/id_rsa.pub"
  fi
}

# Get an overview of the available departmental machines and their current load.
kulmachines() {
  echo -e "Check http://0.0.0.0:10080"
  ssh -L 10080:mysql.cs.kotnet.kuleuven.be:80 kulgateway -N
}

# Create a tunnel for SFTP from outside kotnet
# use 'sftp -P 2222 r0296915@localhost'
kultunnel() {
  ssh -f r0296915@st.cs.kuleuven.be -L 2222:$1.cs.kotnet.kuleuven.be:22 -N
  echo -e "Tunnel created via port 2222. Run \e[1mkulutunnel\e[21m to kill the tunnel."
}
kulutunnel() {
  lsof -ti:2222 | xargs kill -9
}

# Mount the KUL filesystem locally
kulmount() {
  mkdir -pv /tmp/kul
  kultunnel $1
  sshfs -p 2222 r0296915@localhost:$2 /tmp/kul/
  echo -e "Run \e[1mkulumount\e[21m to unmount the filesystem"
  open /tmp/kul
}
kulumount() {
  umount /tmp/kul/
  kulutunnel
}

# ============================================================================
# Directory / Files
# ============================================================================

# flatten a dir
flatten() {
  if [[ -n "$1" ]]; then
    read -r "reply?Flatten folder: are you sure? [Yy] "
  else
    reply=Y
  fi

  if [[ $reply =~ ^[Yy]$ ]]; then
    mv ./*/* .
  fi
}

# delete empty subdirs
prune() {
  if [[ -n $1 ]]; then
    read -r "reply?Prune empty directories: are you sure? [Yy] "
  else
    reply=Y
  fi

  if [[ $reply =~ ^[Yy]$ ]]; then
    find . -type d -empty -delete
  fi
}

# Determine size of a file or total size of a directory
fs() {
  local arg
  if du -b /dev/null > /dev/null 2>&1; then
    arg=-sbh
  else
    arg=-sh
  fi

  if [[ -n "$@" ]]; then
    du "$arg" -- "$@"
  else
    du "$arg" .[^.]* ./*
  fi
}

# Reset current directory to sensible permissions
fixperms() {
    find . -type d -print0 | xargs -0 chmod 755
    find . -type f -print0 | xargs -0 chmod 644
}

# Recursively delete files that match a certain pattern
# (by default delete all `.DS_Store` files)
cleanup() {
    local q="${1:-*.DS_Store}"
    find . -type f -name "$q" -ls -delete
}

# Create a data URI from a file and copy it to the pasteboard
datauri() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    printf "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')" | pbcopy | printf "=> data URI copied to pasteboard.\n"
}

# Extract files
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1    ;;
            *.tar.gz)  tar xzf $1    ;;
            *.bz2)     bunzip2 $1    ;;
            *.rar)     unrar x $1    ;;
            *.gz)      gunzip $1     ;;
            *.tar)     tar xf $1     ;;
            *.tbz2)    tar xjf $1    ;;
            *.tgz)     tar xzf $1    ;;
            *.zip)     unzip $1      ;;
            *.Z)       uncompress $1 ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Usage: zip <file> (<type>)
# Smart archive creator
zipit() {
    emulate -L zsh
    if [[ -n $2 ]] ; then
        case $2 in
            tgz | tar.gz)   tar -zcvf$1.$2 $1 ;;
            tbz2 | tar.bz2) tar -jcvf$1.$2 $1 ;;
            tar.Z)          tar -Zcvf$1.$2 $1 ;;
            tar)            tar -cvf$1.$2  $1 ;;
            gz | gzip)      gzip           $1 ;;
            bz2 | bzip2)    bzip2          $1 ;;
            *)
                echo "Error: $2 is not a valid compression type"
                ;;
        esac
    else
        zipit $1 tar.gz
    fi
}

# ============================================================================
# dev
# ============================================================================

# start up an http server on :8000
pyserve() {
  case "$(python --version 2>&1)" in
      *" 3."*)  python3 -m http.server
                ;;
      *)        python -m SimpleHTTPServer
                ;;
  esac
}

# ============================================================================
# Archiving
# ============================================================================

# Back up a file. Usage "backup filename.txt"
backup() {
    cp $1 ${1}-`date +%Y%m%d%H%M`.backup
}

# vim: ft=sh :
