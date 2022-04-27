# eufon

> *euphony*: _noun_ Harmonious arrangement of sounds in composition; a smooth and agreeable combination of articulate elements in any piece of writing.

A mostly Fennel-based graphical environment tailored for the Pinephone
(other Linux-based mobile devices exist). The principles we aspire to are

* "habitable software" - build the system in such a way that a
  technically competent user may change it to serve their needs,
  potentially even in ways that weren't anticipated in the original
  design.  Emacs has this quality.

* optimised for touchscreens. My phone has no hardware keyboard and few
  hardware buttons, let's play to its strengths instead of compensating for
  its weaknesses

As of 2022 these principles are more aspirational than actual.

## Running it

     $ nix-shell build.nix
     nix-shell$ make run

`make run` executes `lua -e 'os.execute("kiwmi -c init.lua")'`.  This
is suboptimally hairy, at least for the moment: Nix makes a wrapper
script for the Lua executable that has appropriate `LUA_PATH` and
`LUA_CPATH` settings, but it doesn't do the same for kiwmi.


# TODO

## Packages

[X] notifications (crier)
[ ] web browser (just)
[ ] keyboard
[ ] wifi network chooser
[ ] settings: toggle network interfaces, change volume & screen brightness

## Other

[ ] better window management
 - gestures to switch view
 - gesture to launch terminal?
 - some way to kill an app
 - kiwmi may or may not have touch support

[ ] some way to add launcher shortcuts for Fennel functions
[ ] hook up system to session bus, to handle incoming calls
[ ] kiwmi: support reloading config or otherwise making live changes
[ ] why are overlay windows overlapping regular view?
