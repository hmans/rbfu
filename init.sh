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

function rbfu-exec () {
  previous_version=\$RBFU_RUBY_VERSION
  new_version=\$1; shift
  rbfu \$new_version 2>/dev/null
  \$@
  rbfu \$previous_version 2>/dev/null
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
