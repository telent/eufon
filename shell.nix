with import <nixpkgs> {} ;
let p = callPackage ./. {};
in (p.overrideAttrs (o:{
  nativeBuildInputs =  with pkgs; [gdb socat];
  shellHook = ''
    export LUA_PATH=`lua -e 'print(package.path)'`
    export LUA_CPATH=`lua -e 'print(package.cpath)'`
    export EUFON_PATH=`pwd`
  '';
})).override { debug = true; }
