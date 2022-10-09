{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/107875b3-a1ab-4f28-99f4-8647758aca59";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AB43-007E";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a79a05ee-7a16-48ad-ae76-2f38c9fd0626"; }
    ];

  networking = {
    useDHCP = false;                        # Deprecated
    hostName = "blacky";
    networkmanager.enable = true;
    interfaces = {
      enp1s0f0 = {
        useDHCP = true;                     # For versatility sake, manually edit IP on nm-applet.
        #ipv4.addresses = [ {
        #    address = "192.168.0.51";
        #    prefixLength = 24;
        #} ];
      };
      wlp2s0 = {
        useDHCP = false;
        #ipv4.addresses = [ {
        #  address = "192.168.0.51";
        #  prefixLength = 24;
        #} ];  
      };
    };
#    defaultGateway = "192.168.0.1";
#    nameservers = [ "192.168.0.4" ];
    firewall = {
      enable = false;
      #allowedUDPPorts = [ 53 67 ];
      #allowedTCPPorts = [ 53 80 443 9443 ];
    };
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
