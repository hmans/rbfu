# rbfu

**rbfu is a simple tool that manages multiple installations of Ruby and allows you to switch between them on the fly.**

## Installation

### Installing through Homebrew

1. If you're on OS X and using Homebrew, installation is easy:

        brew install rbfu

2. Alternatively, download/clone the rbfu code and run the install script:

        git clone git@github.com:hmans/rbfu.git
        cd rbfu
        ./install.sh

    This will copy the `rbfu` executable to `/usr/local/bin`. If you need to install `rbfu` to a different directory, you can supply the `PREFIX` environment variable, manually copy `bin/rbfu` to a directory of your choosing, or add the provided `bin` directory to your PATH. Either way, all you need to do is make `rbfu` available in your `$PATH`.

3. Add the following initialization line to a **shell startup script** of your choosing (eg. `$HOME/.bash_profile`):

        [ $(which rbfu) ] && eval "$(rbfu --init)"
    
    Or, if you want **automatic version switching** (see below):
    
        [ $(which rbfu) ] && eval "$(rbfu --init --auto)"


### Installing Rubies

rbfu can switch between multiple installations of Ruby on the fly, and it expects them to live within directories named `$HOME/.rbfu/rubies/$VERSION/`. Feel free to install your favourite Ruby versions however you prefer to do it, but we recommend the excellent [ruby-build](https://github.com/sstephenson/ruby-build) tool.

Using ruby-build, here's how you'd install a bunch of popular Ruby versions:

    ruby-build 1.8.7-p352 $HOME/.rbfu/rubies/1.8.7-p352
    ruby-build 1.9.2-p290 $HOME/.rbfu/rubies/1.9.2-p290
    ruby-build 1.9.3-p0   $HOME/.rbfu/rubies/1.9.3-p0

Obviously, each installed Ruby version will have its own self-contained set of gems and associated binaries, so go wild!

## Usage

### Basic Usage

First and foremost, `rbfu` is meant to be invoked _explicitely_, meaning that you can prefix your commands with `rbfu`, and it will make sure those commands run in an environment that is configured to use the specified version of Ruby.

The basic syntax looks like this:

    rbfu [@<version>] <command>

A couple of examples:

    rbfu @1.8.7 rake db:migrate
    rbfu @jruby bundle install
    rbfu @1.9.3 thin start

The `@<version>` parameter is optional; if not specified, rbfu will look for a file named `.rbfu-version` in your current directory, followed by your home directory. This allows you to set global default for your user account, and project-specific overrides.

The `.rbfu-version` files are expected to contain nothing but the Ruby version requested. For example:

    echo "1.9.3-p0" > $HOME/.rbfu_version
    rbfu ruby -v    # will use 1.9.3-p0

If the `@<version>` parameter is given, it will always override whatever versions are specified in available `.rbfu-version` files.

### Modifying the current shell environment

Instead of prefixing all your commands with `rbfu`, you can use `rbfu-env` to reconfigure your current shell session. Example:

    rbfu-env @1.9.3-p0

The above command will reconfigure your currently active shell session to use Ruby 1.9.3-p0. All commands run from within that session will use that version of Ruby, until the shell session is reconfigured again.

**Note:** `rbfu-env` is only available if the `rbfu --init` line has been added to your shell startup script, as described in the "Installation" section above.

### Automatic Version Switching

If your shell startup script invocation of `rbfu --init` includes the `--auto` option (see "Installation"), rbfu will be configured to switch Ruby versions automatically when changing to a new directory containing a `.rbfu-version` file. 

(Also known as "works like RVM mode". Some people don't like this behavior, so it's optional -- simply remove the `--auto` option to disable this.)

## Frequently Asked Questions / Tips & Tweaks

### How do I get shorter version numbers ("1.8.7" instead of "1.8.7-p352")?

rbfu doesn't care what the directories your Rubies are installed in are named. You can install a version like 1.8.7-p352 into `$HOME/.rbfu/rubies/1.8.7`, and it will be available through `rbfu @1.8.7`.

### How do I alias a Ruby version to a different name?

Simply symlink the directory.

    ln -s $HOME/.rbfu/rubies/jruby-1.6.5 $HOME/.rbfu/rubies/jruby
    rbfu @jruby

### How do I create a new gemset?

RVM (a tool similar to rbfu) contains functionality to create completely separate sets of RubyGems (aka gemsets). rbfu does not contain such functionality, nor are we planning on adding it (we believe it's not neccessary; managing gem dependencies with [Bundler](http://gembundler.com/) works just fine, thank you very much.)

If you *really* want or need gemset-like functionality, you can emulate it by simply creating separate Rubies and using them in your projects (eg. `$HOME/.rbfu/rubies/project_a/` and `$HOME/.rbfu/rubies/project_b/`). The overhead isn't all that bad.

### How do I use rbfu with Pow?

Add a `.rbfu-version` file to your project, as well as a `.powrc` file containing the following line:

    . rbfu

This will make Pow start up your project through rbfu. We're working on adding built-in support for rbfu to Pow soon.

### How do I use rbfu with TextMate?

*Coming soon.*

### Why doesn't rbfu just install new Rubies itself?

This could be added easily (it's a simple invocation of `ruby-build`); however, we're actively deciding against it because the most important design decision for rbfu is that it's supposed to *just one thing*, and installing Rubies is not that thing.

Installing new Rubies is easy enough; in fact, if a requested Ruby version is missing, rbfu will print the command required to install it (using ruby-build).

### Uninstalling

If you ever want to get rid of rbfu, make sure the `@system` Ruby is active, remove the rbfu line from your shell startup script, delete the rbfu executable (or run `brew uninstall rbfu`), and finally delete the `$HOME/.rbfu` directory.

    rbfu-env @system
    rm -rf $HOME/.rbfu/

Please note that this will also delete all Ruby versions managed by rbfu, including all
of their installed gems. Destruction is fun!

Also, don't forget to remove the rbfu line from your shell startup script.



## History

### 0.2.0

* First official release, featuring the new "@version" invocation style.


## Contributors

* [Hendrik Mans](http://hmans.net) (author and maintainer)
* [Sebastian Röbke](http://www.xing.com/profile/Sebastian_Roebke) (bash tab completion)

## License

MIT License

Copyright (c) 2011 Hendrik Mans

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
