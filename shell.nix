with import <nixpkgs> {} ;
let p = callPackage ./. {};
in (p.overrideAttrs (o:{
  nativeBuildInputs =  [pkgs.gdb];
  shellHook = ''
    export LUA_PATH=`lua -e 'print(package.path)'`
    export LUA_CPATH=`lua -e 'print(package.cpath)'`
  '';
})).override { debug = true; }
