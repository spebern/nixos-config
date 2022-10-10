{ config, pkgs, ... }:

{
  imports =
    [(import ./hardware-configuration.nix)] ++
    [(import ../../modules/desktop/sway/default.nix)];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "boot.shell_on_fail" ];

    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
      };
      timeout = 1;
    };
  };
}
