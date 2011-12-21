#!/bin/sh

# sanitize parameters
#
set -e
if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

BIN_PATH="${PREFIX}/bin"

# create required directories
#
mkdir -p "${BIN_PATH}"

# copy binaries
#
for file in bin/*; do
  cp "${file}" "${BIN_PATH}"
done

# done!
#
echo "Installed rbfu at ${PREFIX}"
