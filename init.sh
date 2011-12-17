#!/usr/bin/env bash

# parse options
#
for opt in $*; do
  case $opt in
    --auto)
      RBFU_AUTO=1
      ;;
  esac
done    

# configure rbfu
# 
cat <<EOD
alias rbfu-env=". $HOME/.rbfu/bin/rbfu"
export PATH=~/.rbfu/bin:\$PATH
EOD

# automatic mode
#
if [ $RBFU_AUTO ]; then
  cat <<EOD
function cd() {
  if builtin cd "\$@"; then
    [ -f "\$PWD/.rbfu-version" ] && rbfu-env true
  else
    return \$?
  fi
}

[ -f $HOME/.rbfu-version ] && rbfu-env
EOD
fi
