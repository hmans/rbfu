# rbfu

Because I've grown to dislike both RVM and rbenv -- too much magic. Here's
my attempt at a minimal solution.

### Installation

Simply clone the rbfu repository to `$HOME/.rbfu/`:

    git clone git://github.com/hmans/rbfu.git ~/.rbfu

Add the following line to your favorite startup script (eg. `.bash_profile`):

    eval "$(~/.rbfu/bin/rbfu-init)"

Don't forget to reload your shell environment or start a new shell session for the change to be picked up.

Finally, install your favorite Ruby versions through `rbfu-install` (this requires
[ruby-build](https://github.com/sstephenson/ruby-build) to be installed):

    rbfu-install 1.8.7-p352
    rbfu-install 1.9.2-p290
    rbfu-install 1.9.3-p0

### Usage

Switch Ruby versions using the `rbfu` command. For example:

    rbfu 1.8.7-p352

This will modify your current environment with all the paths and variables required for
the selected version of Ruby to be used.