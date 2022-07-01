{ config, lib, pkgs, ... }:
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
      "getty@tty2.service"
      "plymouth-quit.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig =
      let run-eufon = pkgs.writeScript "run-eufon" ''
          #!${pkgs.bash}/bin/bash
          source ${config.system.build.setEnvironment}
          ${pkgs.dbus}/bin/dbus-run-session /home/dan/src/eufon/run.sh
          systemd-cat echo "dbus-run-session $?"
        '';
      in {
        WorkingDirectory = "/home/dan/src/eufon";
        TTYPath = "/dev/tty2";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = "yes";
        PAMName = "login";
        StandardInput = "tty";
        StandardError = "journal";
        StandardOutput = "journal";
        User = "dan";
        ExecStart = run-eufon;
        Restart = "always";
      };
    environment = {
      NIX_PATH = "nixpkgs=${<nixpkgs>}";
    };
  };
  environment.systemPackages = with pkgs; [
    git
  ];
  networking.networkmanager.enable = true;
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
}
