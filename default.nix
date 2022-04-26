{ stdenv
, callPackage
, lua5_3

} :
let
  kiwmi = callPackage ./kiwmi.nix { lua = lua5_3; };
in
stdenv.mkDerivation {
  pname = "eufon";
  version = "0.1";
  buildInputs = [ kiwmi ];
  src = ./.;
}
