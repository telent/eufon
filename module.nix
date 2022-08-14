{ config, lib, pkgs, ... }:
let eufon = pkgs.callPackage ./default.nix {}; in
{
  systemd.services."eufon" = {
    wants = [
      "systemd-machined.service"
      "accounts-daemon.service"
      "systemd-udev-settle.service"
      "dbus.socket"
    ];
    aliases = [ "display-manager.service" ];
    after =  [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "getty@tty2.service"
      "plymouth-quit.service"
      "plymouth-start.service"
      "systemd-logind.service"
      "systemd-udev-settle.service"
    ];
    conflicts = [
      "getty@tty1.service"      # not sure if needed
      "getty@tty2.service"
      "plymouth-quit.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig =
      let run-eufon = pkgs.writeScript "run-eufon" ''
          #!${pkgs.bash}/bin/bash
          source ${config.system.build.setEnvironment}
          ${pkgs.dbus}/bin/dbus-run-session ${eufon}/bin/eufon
          systemd-cat echo "dbus-run-session $?"
        '';
      in {
        WorkingDirectory = "${eufon}";
        TTYPath = "/dev/tty2";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = "yes";
        PAMName = "login";
        StandardInput = "tty";
        StandardError = "journal";
        StandardOutput = "journal";
        SyslogIdentifier = "eufon";
        User = "dan";
        ExecStart = run-eufon;
        Restart = "always";
      };
    environment = {
      NIX_PATH = "nixpkgs=${<nixpkgs>}";
    };
  };
  environment.systemPackages = with pkgs; [
    git eufon
  ];

  boot.postBootCommands = lib.mkOrder (-1) ''
    brightness=4000
    echo "Setting brightness to $brightness"
    echo $brightness > /sys/class/backlight/wled/brightness
  '';

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
}
