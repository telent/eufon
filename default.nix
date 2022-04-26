{ stdenv
, callPackage
, fennel
, lua5_3
} :
let
  fennel_ = (fennel.override { lua = lua5_3; });
  luaWithPackages = lua5_3.withPackages (ps: with ps; [
    (toLuaModule fennel_)
    busted
  ]);
  kiwmi = callPackage ./kiwmi.nix { lua = luaWithPackages; };
in
stdenv.mkDerivation {
  pname = "eufon";
  version = "0.1";
  buildInputs = [ luaWithPackages kiwmi ];
  src = ./.;
}
