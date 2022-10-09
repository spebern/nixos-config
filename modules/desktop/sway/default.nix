{ config, lib, pkgs, ... }:

{
  imports = [ ../../programs/waybar.nix ];

  hardware.opengl.enable = true;

  environment = {
    variables = {
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
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
  };
  networking.firewall.allowedTCPPorts = [ 5900 ];   # Used for vnc

  xdg.portal = {                                  # Required for flatpak with windowmanagers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
