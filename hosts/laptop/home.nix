{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/sway/home.nix
    ];

  home = {
    packages = with pkgs; [
      # Power Management
      auto-cpufreq
      tlp
    ];
  };

  programs = {
    alacritty.settings.font.size = 11;
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    cbatticon = {
      enable = true;
      criticalLevelPercent = 10;
      lowLevelPercent = 20;
      iconType = null;
   };
  };
}
