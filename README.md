# eufon

**Broken, not ready for use**

> *euphony*: _noun_ Harmonious arrangement of sounds in composition; a smooth and agreeable combination of articulate elements in any piece of writing.

A mostly Fennel-based graphical environment tailored for Linux-based
mobile devices. The principles we aspire to are

* "habitable software" - build the system in such a way that a
  technically competent user may change it to serve their needs,
  potentially even in ways that weren't anticipated in the original
  design.  Emacs has this quality.

* optimised for touchscreens. My phone has no hardware keyboard and few
  hardware buttons, let's play to its strengths instead of compensating for
  its weaknesses

As of 2022 these principles are more aspirational than actual. _This
repo is basically in an advanced state of brokenness_

## Running the shell/apps locally

Eufon is intendfed for phones, but you may prefer to develop on a
desktop device of some kind, especially if you're changing C code and
have that edit/compile run cycle to go round. You can start the shell
locally with

     $ nix-shell --run "kiwmi -c init.lua"

`shell.nix` sets `LUA_PATH` and `LUA_CPATH` settings appropriately -
if you want to write a real derivation (I'll get to it eventually)
you'll need to sort that out yourself. Nix generates a wrapper script
for the Lua interpreter itself, but it doesn't do the same for kiwmi.

## Connecting to the repl

If you are using the example rc.fnl, it opens a Unix socket to which
you can connect to interact with a Fennel REPL. The `eufonctl`
script is a wrapper around [socat](http://www.dest-unreach.org/socat/) 

    $ eufonctl $WAYLAND_DISPLAY


## Building for a device

Eufon can be installed as a [Mobile NixOS](https://github.com/NixOS/mobile-nixos/) module, by adding
`module.nix` to the `imports` in `your configuration.nix`. For example, on my development phone I
have 

```nix
  imports = [
    (import <mobile-nixos/lib/configuration.nix> {
      device = "motorola-potter";
    })
    /home/dan/src/phoen/eufon/module.nix
  ];
```

Instructions for using Mobile NixOS are currently outside the scope of
this README.



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
	- finish adding touch support to Kiwmi - https://github.com/buffet/kiwmi/pull/64

- [ ] some way to add launcher shortcuts for Fennel functions
- [ ] hook up system to session bus, to handle incoming calls
- [X] kiwmi: support reloading config or otherwise making live changes
- [ ] why are overlay windows overlapping regular view?
- [ ] screen lock
