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
alias rbfu-env=". $HOME/.rbfu/bin/rbfu"
export PATH=~/.rbfu/bin:\$PATH
[ -f $HOME/.rbfu-version ] && rbfu-env
EOD

# optional cd hack
#
if [ $RBFU_CD_HACK ]; then
  cat <<EOD
function cd() {
  if builtin cd "\$@"; then
    [ -f "\$PWD/.rbfu-version" ] && . rbfu
  else
    return \$?
  fi
}
EOD
fi
