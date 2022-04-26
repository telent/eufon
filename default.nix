{ stdenv
, callPackage
, fetchFromGitHub

, fennel
, gobject-introspection
, gtk3
, gtk-layer-shell
, lua5_3
} :
let
  lua = lua5_3;
  fennel_ = (fennel.override { lua = lua5_3; });
  luaDbusProxy = callPackage ./lua-dbus-proxy.nix {
    inherit (lua.pkgs) lgi buildLuaPackage;
    inherit lua;
  };
  inifile = lua.pkgs.buildLuaPackage rec {
    pname  = "inifile";
    name = "${pname}-${version}";
    version  = "1.0.2";
    src = fetchFromGitHub {
      owner = "bartbes";
      repo = "inifile";
      rev = "f0b41a8a927f3413310510121c5767021957a4e0";
      sha256 = "1ry0q238vbp8wxwy4qp1aychh687lvbckcf647pmc03rwkakxm4r";
    };
    buildPhase = ":";
    installPhase = ''
        mkdir -p "$out/share/lua/${lua.luaversion}"
        cp inifile.lua "$out/share/lua/${lua.luaversion}/"
      '';
  };

  luaWithPackages = lua5_3.withPackages (ps: with ps; [
    (toLuaModule fennel_)
    inifile
    luafilesystem
    lgi
    luaposix
    luaDbusProxy
    penlight

  ]);
  kiwmi = callPackage ./kiwmi.nix { lua = lua5_3; };
in
stdenv.mkDerivation {
  pname = "eufon";
  version = "0.1";
  buildInputs = [
    luaWithPackages
    kiwmi
    gobject-introspection.dev
    gtk-layer-shell
    gtk3
  ];

  src = ./.;
}
