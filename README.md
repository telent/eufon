# eufon

**Broken, not ready for use**

> *euphony*: _noun_ Harmonious aqrrangement of sounds in composition; a smooth and agreeable combination of articulate elements in any piece of writing.

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

## Building for a device

To build an image, unpack [Mobile NixOS](https://github.com/NixOS/mobile-nixos/) in a sibling directory
of this repo (so that `../mobile-nixos` addresses it) and then do
something like this (substituing an appropriate device name for
`motorola-potter`)

    $ nix-build ../mobile-nixos/ -I mobile-nixos-configuration=./configuration.nix --argstr device motorola-potter -A build.default

You are warmly encouraged to refer to the [Mobile Nixos
docs](https://mobile.nixos.org/devices/) for how to use this image.

Once you have your device up and running and you can ssh into it
somehow (this may take further research, again I invite you to look at
the Mobile Nixos site) then you should be able to use
`nix-copy-closure` to update it without reinstalling.

    $ phone=myphone.lan
    $ nix-build ../mobile-nixos/ -I mobile-nixos-configuration=./configuration.nix --argstr device motorola-potter -A config.system.build.toplevel
    $ nix-copy-closure --to root@${phone} --include-outputs \
       ./result && ssh root@${phone} \
       `readlink result`/bin/switch-to-configuration switch


## Running the shell/apps locally

You may prefer to develop on a desktop device of some kind, especially
if you're changing C code and have that edit/compile run cycle to go
round. You can start the shell locally with

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
	- finish adding touch support to Kiwmi - https://github.com/buffet/kiwmi/pull/64

- [ ] some way to add launcher shortcuts for Fennel functions
- [ ] hook up system to session bus, to handle incoming calls
- [X] kiwmi: support reloading config or otherwise making live changes
- [ ] why are overlay windows overlapping regular view?
- [ ] screen lock
