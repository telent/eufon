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

     $ nix-shell --run "kiwmi -c init.lua"

`shell.nix` sets `LUA_PATH` and `LUA_CPATH` settings appropriately -
if you want to write a real derivation (I'll get to it eventually)
you'll need to sort that out yourself. Nix generates a wrapper script
for the Lua interpreter itself, but it doesn't do the same for kiwmi.

## Connecting to the repl

If you are using the example rc.fnl, it opens a Unix socket that you
can connect to and interact with a Fennel REPL. I use
[socat](http://www.dest-unreach.org/socat/) for this purpose:

    $ socat - unix-connect:${XDG_RUNTIME_DIR}/kiwmi-repl.wayland-1.socket


# TODO

## Packages

- [X] notifications (crier)
- [X] web browser (just)
- [ ] keyboard
- [ ] wifi network chooser
- [ ] settings: toggle network interfaces, change volume & screen brightness

## Other

- [ ] better window management
	- gestures to switch view
	- gesture to launch terminal?
	- some way to kill an app
	- kiwmi may or may not have touch support

- [ ] some way to add launcher shortcuts for Fennel functions
- [ ] hook up system to session bus, to handle incoming calls
- [X] kiwmi: support reloading config or otherwise making live changes
- [ ] why are overlay windows overlapping regular view?
- [ ] screen lock
