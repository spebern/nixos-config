#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./blacky
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix       
#   └─ ./modules
#       ├─ ./desktop
#       │   └─ ./hyprland
#       │       └─ hyprland.nix
#       ├─ ./modules
#       │   └─ ./programs
#       │       └─ waybar.nix
#       └─ ./hardware
#           └─ default.nix
#

{ config, pkgs, user, ... }:

{
  imports =                                 # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/hyprland/default.nix)] ++      # Window Manager
    [(import ../../modules/desktop/virtualisation/docker.nix)] ++  # Docker
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "amdgpu" ];

    boot = {                                      # Boot options
      kernelPackages = pkgs.linuxPackages_latest;
      #initrd.kernelModules = [ "amdgpu" ];       # Video drivers

      loader = {                                  # For legacy boot:
        systemd-boot = {
          enable = true;
          configurationLimit = 5;                 # Limit the amount of configurations
        };
        efi.canTouchEfiVariables = true;
        timeout = 5;                              # auto select time
      };
    };
  };

  hardware.sane = {                           # Used for scanning with Xsane
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
      simple-scan
    ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    tlp.enable = true;                      # TLP and auto-cpufreq for power management
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
    #xserver = {
    #  libinput = {                          # Trackpad support & gestures
    #    touchpad = {
    #      tapping = true;
    #      scrollMethod = "twofinger";
    #      naturalScrolling = true;            # The correct way of scrolling
    #      accelProfile = "adaptive";          # Speed settings
    #      #accelSpeed = "-0.5";
    #      disableWhileTyping = true;
    #    };
    #  };
    #  resolutions = [
    #    { x = 1920; y = 1200; }
    #    { x = 2560; y = 1600; }
    #  ];
    #};
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];
}
