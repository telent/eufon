{ lib
, stdenv
, fetchFromGitHub
, cairo
, fennel
, git
, glib
, libdrm
, libinput
, libxcb
, libxkbcommon
, libxml2
, lua
, meson
, ninja
, pango
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wlroots
, xwayland
}:

stdenv.mkDerivation rec {
  pname = "kiwmi";
  version = "20220315";

  src = ./kiwmi;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    cairo
    fennel
    glib
    git # "needed to make the version string", le sigh
    libdrm
    libinput
    libxcb
    libxkbcommon
    libxml2
    lua
    pango
    wayland
    wayland-protocols
    wlroots
    xwayland
  ];

#  mesonFlags = [ "-Dxwayland=enabled" ];
}
