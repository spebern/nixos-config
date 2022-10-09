{ config, pkgs, ... }:

{
  imports =
    [(import ./hardware-configuration.nix)] ++
    [(import ../../modules/desktop/sway/default.nix)];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/vda";
      };
      timeout = 1;
    };
  };
}
