{ stdenv
, callPackage
, fennel
, gobject-introspection
, gtk3
, gtk-layer-shell
, lua5_3
} :
let
  fennel_ = (fennel.override { lua = lua5_3; });
  luaWithPackages = lua5_3.withPackages (ps: with ps; [
    (toLuaModule fennel_)
    lgi
    luaposix
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
