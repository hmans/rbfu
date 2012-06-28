# rbfu

**rbfu is a simple tool that manages multiple installations of Ruby and allows you to switch between them on the fly.**

First and foremost, it supports an explicit invocation style that takes a Ruby version as a command line parameter or reads it from `.ruby-version`, if present:

``` shell
$ rbfu @1.8.7 ruby -v
$ rbfu ruby -v         # reads from .ruby-version
```

You can use `rbfu-env` to modify the current shell session:

``` shell
$ rbfu-env @1.8.7
$ rbfu-env         # reads from .ruby-version
```

And, of course, there's also an (optional) automatic mode that automatically modifies your shell session when you cd into a directory containing a `.ruby-version` file.

## Rationale

Most Ruby developers like to keep different self-compiled versions of Ruby on their systems so they can switch back and forth between them depending on the project they're working on. Most of them use [RVM](https://rvm.io/) to do this; others prefer [rbenv](https://github.com/sstephenson/rbenv/). Both are great tools, but do a little bit too much for my taste.

See, the thing is: switching Ruby versions is actually a trivial operation, since it merely involves modifying a couple of environment variables (`PATH`, `GEM_HOME` and `GEM_PATH`). Both RVM and rbenv go through a lot of hassle in order to eventually perform this very simple operation.

**rbfu** is trying to keep things simple; it's a small shell script that doesn't do much else beyond changing the variables mentioned above.

I believe that software should be small and focused. rbfu doesn't come with support for gemsets (a feature I personally disagree with), nor will it compile Ruby for you (it's easy enough with [ruby-build](https://github.com/sstephenson/ruby-build/)).

It just does one thing, and I think it does it really well.

If this appeals to you, please give rbfu a spin.


## Installing rbfu

### Using Homebrew

If you're on OS X and using [Homebrew](http://mxcl.github.com/homebrew/), you can install rbfu through the following command:

    brew install http://git.io/rbfu

Please don't forget to follow the instructions provided by the above command.

### Manual Installation

If you're not using Homebrew, don't worry; installing rbfu is very straight-forward (and should work fine on Linux & friends, too).

1. Download/clone the rbfu code and run the install script:

        git clone git://github.com/hmans/rbfu.git
        cd rbfu
        ./install.sh

    This will copy the `rbfu` executable to `/usr/local/bin`. If you need to install `rbfu` to a different directory, you can supply the `PREFIX` environment variable, manually copy `bin/rbfu` to a directory of your choosing, or add the provided `bin` directory to your PATH. Either way, all you need to do is make `rbfu` available in your `$PATH`.

2. Add the following initialization line to a **shell startup script** of your choosing (eg. `$HOME/.bash_profile`):

        eval "$(rbfu --init --auto)"

    Or, if you don't want RVM-style automatic version switching (see below), leave out the `--auto` parameter:

        eval "$(rbfu --init)"


### Installing Rubies

rbfu can switch between multiple installations of Ruby on the fly, and it expects them to live within directories named `$HOME/.rbfu/rubies/$VERSION/`. Feel free to install your favourite Ruby versions however you prefer to do it, but I recommend the excellent [ruby-build](https://github.com/sstephenson/ruby-build) tool.

Using ruby-build, here's how you'd install a bunch of popular Ruby versions:

    ruby-build 1.8.7-p352 $HOME/.rbfu/rubies/1.8.7-p352
    ruby-build 1.9.2-p290 $HOME/.rbfu/rubies/1.9.2-p290
    ruby-build 1.9.3-p194 $HOME/.rbfu/rubies/1.9.3-p194

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

The `@<version>` parameter is optional; if not specified, rbfu will look for a file named `.ruby-version` (or, alternatively, `.rbfu-version`) in your current directory, followed by your home directory. This allows you to set global default for your user account, and project-specific overrides.

The `.ruby-version` files are expected to contain nothing but the Ruby version requested. For example:

    echo "1.9.3-p0" > $HOME/.ruby-version
    rbfu ruby -v    # will use 1.9.3-p0

If the `@<version>` parameter is given, it will always override whatever versions are specified in available `.ruby-version` files.

### Modifying the current shell environment

Instead of prefixing all your commands with `rbfu`, you can use `rbfu-env` to reconfigure your current shell session. Example:

    rbfu-env @1.9.3-p0

The above command will reconfigure your currently active shell session to use Ruby 1.9.3-p0. All commands run from within that session will use that version of Ruby, until the shell session is reconfigured again.

**Note:** `rbfu-env` is only available if the `rbfu --init` line has been added to your shell startup script, as described in the "Installation" section above.

### Automatic Version Switching

If your shell startup script invocation of `rbfu --init` includes the `--auto` option (see "[Installating rbfu](#installing-rbfu)"), rbfu will be configured to switch Ruby versions automatically when changing to a new directory containing a `.ruby-version` file.

(Also known as "works like RVM mode". Some people don't like this behavior, so it's optional -- simply remove the `--auto` option to disable this.)

## Frequently Asked Questions / Tips & Tweaks

### How do I assign shorter names to my Rubies ("1.8.7" instead of "1.8.7-p352")?

rbfu doesn't care what the directories your Rubies are installed in are named. You can install a version like 1.8.7-p352 into `$HOME/.rbfu/rubies/1.8.7`, and it will be available through `rbfu @1.8.7`.

### How do I alias a Ruby version to a different name?

Simply symlink the directory.

    ln -s $HOME/.rbfu/rubies/jruby-1.6.5 $HOME/.rbfu/rubies/jruby
    rbfu @jruby

### How do I create a new gemset?

RVM (a tool similar to rbfu) contains functionality to create completely separate sets of RubyGems (aka gemsets). rbfu does not contain such functionality, nor am I planning on adding it (I believe it's not neccessary; managing gem dependencies with [Bundler](http://gembundler.com/) works just fine, thank you very much.)

If you *really* want or need gemset-like functionality, you can emulate it by simply creating separate Rubies and using them in your projects (eg. `$HOME/.rbfu/rubies/project_a/` and `$HOME/.rbfu/rubies/project_b/`). The overhead isn't all that bad.

### How do I use rbfu with Pow?

Add a `.ruby-version` file to your project, as well as a `.powrc` file containing the following line:

    source rbfu

This will make Pow start up your project through rbfu. We're working on adding built-in support for rbfu to Pow soon.

### Why doesn't rbfu just install new Rubies itself?

This could be added easily (it's a simple invocation of `ruby-build`); however, I'm actively deciding against it because the most important design decision for rbfu is that it's supposed to do *just one thing*, and installing Rubies is not that thing.

Installing new Rubies is easy enough; in fact, if a requested Ruby version is missing, rbfu will print the command required to install it (using ruby-build).

### Uninstalling

If you ever want to get rid of rbfu, make sure the `@system` Ruby is active, remove the rbfu line from your shell startup script, delete the rbfu executable (or run `brew uninstall rbfu`, if using Homebrew), reload your environment, and finally delete the `$HOME/.rbfu` directory.

    rbfu-env @system
    rm -rf $HOME/.rbfu/

Please note that this will also delete all Ruby versions managed by rbfu, including all
of their installed gems. Destruction is fun!

Also, don't forget to remove the rbfu line from your shell startup script.



## History

### 0.3.0

* rbfu now also looks for `.ruby-version` files, using the same format as the `.rbfu-version` files supported previously. `.ruby-version` is being established as a common Ruby version specification format, with support being added to RVM, rbenv and other Ruby version managers.
* zsh completion compatibility (thanks to @dbloete)
* improved compatibility with bash < 4.0

### 0.2.0

* First official release, featuring the new "@version" invocation style.

## Contributors

* [Hendrik Mans](http://hmans.net) (author and maintainer)
* [Sebastian Röbke](http://www.xing.com/profile/Sebastian_Roebke) (bash tab completion)
* [Dennis Reimann](https://github.com/dbloete) (zsh completion compatibility)

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
