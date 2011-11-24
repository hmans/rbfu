#!/usr/bin/env bash

# parse options
#
for opt in $*; do
  case $opt in
    --cd-hack)
      RBFU_CD_HACK=1
      ;;
  esac
done    

# configure rbfu
# 
cat <<EOD
function rbfu () {
  eval "\`$HOME/.rbfu/libexec/rbfu-activate \$1\`"
}

[ -f $HOME/.rbfu-version ] && rbfu
EOD

# optional cd hack
#
if [ $RBFU_CD_HACK ]; then
  cat <<EOD
function cd() {
  if builtin cd "\$@"; then
    [ -f "\$PWD/.rbfu-version" ] && rbfu
  else
    return \$?
  fi
}
EOD
fi

# bash completion
#
cat <<EOD
_rbfu() {
  cur="\${COMP_WORDS[COMP_CWORD]}"
  opts=\$(ls $HOME/.rbfu/rubies)
  COMPREPLY=( \$(compgen -W "\${opts} system" -- \${cur}) )
}
complete -o nospace -F _rbfu rbfu
EOD