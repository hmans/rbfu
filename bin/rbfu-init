#!/usr/bin/env bash

cat <<EOD
function rbfu () {
  eval "\`rbfu-activate \$1\`"
}

export PATH=~/.rbfu/bin:\$PATH
[ -f $HOME/.rbfu-version ] && rbfu
EOD
