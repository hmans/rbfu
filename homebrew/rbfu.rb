# This is a formula for homebrew, the popular package management
# system for OS X. rbfu has so far not been accepted into the official
# homebrew distribution, but luckily homebrew can also use custom
# formulas, which is why I'm providing it here.

require 'formula'

class Rbfu < Formula
  url 'https://github.com/hmans/rbfu/tarball/v0.3.0'
  homepage 'https://github.com/hmans/rbfu'
  md5 '1a4bca11d3dc61bcbe61468f6ba4b6be'
  head 'https://github.com/hmans/rbfu.git'

  def install
    prefix.install Dir['*']
  end

  def test
    system "rbfu --help"
  end

  def caveats; <<-EOS.undent
    Please add the following line to your favorite shell startup script:

        eval "$(rbfu --init --auto)"

    If you don't want RVM-like automatic version switching on directory
    changes, remove the --auto option:

        eval "$(rbfu --init)"

    Additional tips & tricks can be found in rbfu's README:

        https://github.com/hmans/rbfu#readme

    Enjoy!

    EOS
  end
end
