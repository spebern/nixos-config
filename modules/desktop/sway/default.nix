{ config, lib, pkgs, ... }:

{
  imports = [ ../../programs/waybar.nix ];

  hardware.opengl.enable = true;

  environment = {
    variables = {
      # WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        autotiling
        swayidle
        wev
        wl-clipboard
        kanshi
        xwayland
        wayvnc
      ];
    };
    waybar = {
      enable = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 5900 ];   # Used for vnc

  xdg.portal = {                                  # Required for flatpak with windowmanagers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
