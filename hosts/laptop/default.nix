{ config, pkgs, user, ... }:

{
  imports =
    [(import ./hardware-configuration.nix)] ++
    [(import ../../modules/desktop/sway/default.nix)] ++
    [(import ../../modules/desktop/virtualisation/docker.nix)] ++
    (import ../../modules/hardware);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "amdgpu" ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 5;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  environment = {
    systemPackages = with pkgs; [
      simple-scan
      iwd
    ];
  };

  networking.networkmanager.wifi.backend = "iwd";

  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    tlp.enable = true;                       # TLP and auto-cpufreq for power management
    #logind.lidSwitch = "ignore";            # Laptop does not go to sleep when lid is closed
    auto-cpufreq.enable = true;
    blueman.enable = true;
    printing = {                            # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
    avahi = {                               # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                           # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];
}
