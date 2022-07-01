{ config, lib, pkgs, ... }:

# configuration.nix contains settings applicable to _my_ pinephone
# pinephone.nix contains settings applicable to eufon on pinephones.
# module.nix contains settings applicable to eufon generally

{
  config = {
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "ondemand";
    };
    mobile.boot.stage-1.firmware = [
      config.mobile.device.firmware
    ];
    hardware.sensor.iio.enable = true;
    hardware.firmware = [ config.mobile.device.firmware ];

    services.fwupd = {
      enable = true;
    };

    environment.systemPackages =
      let refresh-bootfs = (import ./refresh-bootfs.nix { inherit config pkgs lib; });
      in with pkgs; [
      dtc
      file
      refresh-bootfs
    ];

    environment.etc."fwupd/remotes.d/testing.conf" = {
      mode = "0644";
      text = ''
        [fwupd Remote]

        Enabled=true
        Title=Linux Vendor Firmware Service (testing)
        MetadataURI=https://cdn.fwupd.org/downloads/firmware-testing.xml.gz
        ReportURI=https://fwupd.org/lvfs/firmware/report
        OrderBefore=lvfs,fwupd
        AutomaticReports=false
        ApprovalRequired=false
      '';
    };

    nixpkgs = {
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "pine64-pinephone-firmware"
      ];

    };
#    boot.loader.generic-extlinux-compatible.enable = lib.mkForce true;
    hardware.opengl = {
      enable = true;
      driSupport = true;
    };

  };
}
