{ config, pkgs, lib,  ... }:

# nixos/mobile-nixos don't currently (June 2022) update the kernel and
# initrd used by the bootloader when nixos-rebuild is run. This is a
# workaround until they do. Mount your boot filesystem somewhere
# and run "refresh-bootfs /path/to/mounted/bootfs" after switching
# configuration

let
  inherit (config.mobile.outputs) recovery stage-0;
  inherit (pkgs) writeScriptBin buildPackages imageBuilder runCommandNoCC;

  kernel = stage-0.mobile.boot.stage-1.kernel.package;
  kernel_file = "${kernel}/${if kernel ? file then kernel.file else pkgs.stdenv.hostPlatform.linux-kernel.target}";
  # bootscr = runCommandNoCC "boot.scr" {
  #   nativeBuildInputs = [
  #     buildPackages.ubootTools
  #   ];
  # } ''
  #   mkimage -C none -A arm64 -T script -d {bootcmd} $out
  # '';

in writeScriptBin "refresh-bootfs" ''
  #!${pkgs.runtimeShell}
  test -n "$1" || exit 1
  test -d "$1" || exit 1
  cd $1
  test -f ./boot.scr || exit 1
  mkdir -vp mobile-nixos/{boot,recovery}
  (
  cd mobile-nixos/boot
  cp -v ${stage-0.mobile.outputs.initrd} stage-1
  cp -v ${kernel_file} kernel
  cp -vr ${kernel}/dtbs dtbs
  )
  (
  cd mobile-nixos/recovery
  cp -v ${recovery.mobile.outputs.initrd} stage-1
  cp -v ${kernel_file} kernel
  cp -vr ${kernel}/dtbs dtbs
  )
  #  cp -v {bootscr} ./boot.scr
''
