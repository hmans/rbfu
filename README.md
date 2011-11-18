# rbfu

Because I've grown to dislike both RVM and rbenv -- too much magic. Here's
my attempt at a minimal solution.

### Installation

Simply clone the rbfu repository to `$HOME/.rbfu/`:

    git clone git://github.com/hmans/rbfu.git ~/.rbfu

Add `$HOME/.rbfu/bin` to your path (eg. in `.profile` or `.bashrc`):

    export PATH=$HOME/.rbfu/bin:$PATH

Then install your favorite Ruby versions through `ruby-build`:

    ruby-build 1.8.7-p352 /Users/hmans/.rbfu/rubies/1.8.7-p253
    ruby-build 1.9.2-p290 /Users/hmans/.rbfu/rubies/1.9.2-p290

### Usage

Please note that the current interface is **highly experimental and likely to change**; I'm still in the process of figuring out how this thing is best put to use. :)

Simply prefix your commands with `rbfu`; it will pick up the version of Ruby to use from an `.rbfu-version` file in the current directory. Examples:

    rbfu ruby -v    # display version of active Ruby
    rbfu gem -v     # display version of RubyGems
    rbfu bundle exec rake db:migrate   # execute a rake task

You can also source `rbfu` in order to apply its environment changes to your current shell session:

    . rbfu
    ruby -v
    gem -v
    # etc.

More documentation coming soon.
