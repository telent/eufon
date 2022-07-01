with import <nixpkgs> {} ;
let p = callPackage ./. {};
in (p.overrideAttrs (o:{
  nativeBuildInputs =  with pkgs; [gdb socat];
  shellHook = ''
    export LUA_PATH=`lua -e 'print(package.path)'`
    export LUA_CPATH=`lua -e 'print(package.cpath)'`
    # this is a shell function mostly so that I can comment it out
    # to experiment with starting sway or tinywl or something else
    # to see how they behave if kiwmi is being weird
    start_eufon(){
      kiwmi -c init.lua;
    }
  '';
})).override { debug = true; }
