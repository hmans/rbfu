# rbfu

**rbfu manages multiple versions of Ruby and allows you to switch between them on the fly.**

Yes, just like [RVM](http://beginrescueend.com/) and [rbenv](https://github.com/sstephenson/rbenv)! "Why, good sir", I hear you ask, "do we need another one of these?"
Well, there isn't really anything wrong with RVM nor rbenv; they simply don't work the way I
would prefer this stuff to work. So one day I decided to scratch my own itch; there you go.
As to the details of that itch, I could probably write a nice, big blog article about this; let's just say for now that I believe both RVM and, ironically, rbenv are simply trying to do too much.

See, rbfu does one thing and one thing only:

* **Switch to a specified version of Ruby.** It does so by modifying the current environment with a modified `$PATH` and various related variables. It doesn't override anything in your system at all; as far as all the beautiful things you code and run are concerned, rbfu is completely, entirely, utterly invisible.

rbfu (especially compared to RVM and rbenv) **does not do any of the following**:

* **Switch Ruby versions automagically.** Out of the box, you have to switch versions explicitly (eg. `rbfu 1.9.3-p0`). If you really, _really_ want RVM-like behaviour, you can configure rbfu to automatically pick up `.rbfu-version` files, but this feature should be considered experimental. And unloved. Highly unloved.
* **Install Rubies.** Well, there's a little helper command available that hooks into the excellent [ruby-build](https://github.com/sstephenson/ruby-build), but you can also compile your Rubies yourself if that is what pushes your buttons, you dirty old girl.
* **Override existing shell functions or executables.** I've never been a big fan of RVM hooking into `cd`, but in my opinion rbenv's shim executable approach is even worse. rbfu completely and entirely stays in the background. Like a good roadie. Or a silent assassin. Except that it doesn't kill you.
* **Manage gemsets.** Seriously, please just use [Bundler](http://gembundler.com/) for managing your gems, it's great.

### Installation

For the time being, rbfu assumes it's running from `$HOME/.rbfu/`. Install it by simply cloning the rbfu repository:

    git clone git://github.com/hmans/rbfu.git ~/.rbfu

Add the following line to your favorite startup script (eg. `.bash_profile`):

    [ -d "$HOME/.rbfu" ] && eval "$($HOME/.rbfu/init.sh)"

**Experimental Feature for Dangerous Cats:** If you want rbfu to automatically switch Ruby versions when you enter directories containing `.rbfu-version` files (kinda like RVM does it), you can supply the `--cd-hack` option here. In this case, the above line would read:

    [ -d "$HOME/.rbfu" ] && eval "$($HOME/.rbfu/init.sh --cd-hack)"

Don't forget to reload your shell environment or start a new shell session for the change to be picked up.

Finally, install your favorite Ruby versions. The most convenient way to do this is through the
excellent [ruby-build](https://github.com/sstephenson/ruby-build):

    ruby-build 1.8.7-p352 $HOME/.rbfu/rubies/1.8.7-p352
    ruby-build 1.9.2-p290 $HOME/.rbfu/rubies/1.9.2-p290
    ruby-build 1.9.3-p0 $HOME/.rbfu/rubies/1.9.3-p0

If you prefer to compile your Rubies manually, please feel free to do so. As you can see from the above example, rbfu expects Rubies to live in directories named `$HOME/.rbfu/rubies/$VERSION/`. Go wild.

### Usage

#### Activating a specific Ruby version

Switch Ruby versions using the `rbfu` command. For example:

    rbfu 1.8.7-p352

This will modify your current environment with all the paths and variables required for
the selected version of Ruby to be used. Yay!

#### Reverting to the default system Ruby

    rbfu system

This will remove all of rbfu's traces from your current environment, reverting to whatever
Ruby version your system is providing (if at all).

#### Setting project and user defaults

When you don't pass a version number to `rbfu`, it will try to find an `.rbfu-version` file
in the current directory (and, if that fails, in your home directory). This allows you to
configure your code projects (or your user account) for specific versions of Ruby, without having to specify the Ruby version every time you invoke rbfu.

Example:

    $ echo "1.9.3-p0" > .rbfu-version
    $ rbfu
    Activated Ruby 1.9.3-p0 (from /Users/hmans/src/pants/.rbfu-version)

Note that you can still override this by passing a version
on the command line:

    $ cat .rbfu-version
    1.9.3-p0
    $ rbfu 1.8.7-p352
    Activated Ruby 1.8.7-p352 (from command line)

Note that if a `$HOME/.rbfu-version` file is present, rbfu will initially activate the Ruby version mentioned therein when the environment is created (ie., from your shell startup script).

#### Switching Ruby versions automagically

If you have the `--cd-hack` option enabled (see the Installation section for details), rbfu will look for these files whenever you switch to a new directory, and act upon them automatically. Please note that this functionality is experimental (and probably buggy/dangerous). It is generally recommended you switch Ruby versions manually; this functionality is merely provided for people who really, _really_ want rbfu to kind of work like RVM. _SEE, YOU MADE ME ADD THIS. I HOPE YOU ENJOY IT. SNARL, SNARL, GRUNT ETC._

### Uninstalling

If you ever want to get rid of rbfu, make sure the system Ruby is active, then simply delete the `$HOME/.rbfu` directory.

    rbfu system
    rm -rf $HOME/.rbfu/

Please note that this will also delete all Ruby versions managed by rbfu, including all
of their installed gems. Destruction is fun!

### History

Yo dawg, this stuff is so fresh, it doesn't even have a version number yet. Hang in there!

### License

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
