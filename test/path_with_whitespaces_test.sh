# saving original state
ORIG_PATH="${PATH}"
TEST_PATH="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin:${PATH}"

PATH="${TEST_PATH}"
echo "* TEST:    \$PATH=$PATH"
echo

echo "testing current rbfu 'path_remove' command - should mess up PATH"
source `which rbfu`
path_remove "/foo"
echo "* FAIL:    \$PATH=$PATH"
echo

PATH="${TEST_PATH}"

echo "testing modified rbfu 'path_remove' command - should not mess up PATH"
source ./bin/rbfu
path_remove "/foo"
echo "* SUCCESS: \$PATH=$PATH"
echo

# resetting PATH to ORIGINAL state
PATH="${ORIG_PATH}"
