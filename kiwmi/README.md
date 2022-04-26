<h1 align="center">kiwmi</h1>
<p align="center"><i>A fully programmable Wayland Compositor</i></p>
<hr><p align="center">
  <img alt="Stars" src="https://img.shields.io/github/stars/buffet/kiwmi.svg?label=Stars&style=flat" />
  <a href="https://cirrus-ci.com/github/buffet/kiwmi"><img alt="Build Status" src="https://api.cirrus-ci.com/github/buffet/kiwmi.svg"></a>
  <a href="https://github.com/buffet/kiwmi/issues"><img alt="GitHub Issues" src="https://img.shields.io/github/issues/buffet/kiwmi.svg"/></a>
  <a href="https://github.com/buffet/kiwmi/graphs/contributors"><img alt="GitHub Contributors" src="https://img.shields.io/github/contributors/buffet/kiwmi"></a>
</p>

kiwmi is a work-in-progress extensive user-configurable Wayland Compositor.
kiwmi specifically does not enforce any logic, allowing for the creation of Lua-scripted behaviors, making arduous tasks such as modal window management become a breeze.
New users should be aware of the  steep learning curve present, however this will be reduced as the project matures.

Got any questions or want to discuss something? Join us in [#kiwmi on irc.libera.chat](https://web.libera.chat/gamja/?channels=#kiwmi)!


## Documentation

Documentation for the API can be found in [lua_docs.md](lua_docs.md).

Additionally `kiwmic` can be used to send a single lua string to kiwmi for direct evaluation.

For example:

```
$ kiwmic 'return kiwmi:focused_view():id()'
94036737803088.0
```

## Getting Started

The dependencies required are:

- [wlroots](https://gitlab.freedesktop.org/wlroots/wlroots)
- lua or luajit
- pixman
- meson (build)
- ninja (build)
- git (build, optional)

### Building

After cloning/downloading the project and ensuring all dependencies are installed, building is as easy as running

```
$ meson build
$ ninja -C build
```

If you plan to use luajit instead, use the following commands instead.

```
$ meson -Dlua-pkg=luajit build
$ ninja -C build
```

Installing is accomplished with the following command:

```
# ninja -C build install
```


## Contributing

Contributions are welcomed, especially while the project is in a heavy WIP stage.
If you believe you have a valid concern, read the [CONTRIBUTING](https://github.com/buffet/kiwmi/blob/master/CONTRIBUTING.md) document and please file an issue on the [issues page](https://github.com/buffet/kiwmi/issues/new).

For clarifications or suggestions on anything, please don't hesitate to contact me.
