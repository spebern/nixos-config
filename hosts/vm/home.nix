{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/sway/home.nix
    ];

  home = {
    # Specific packages for desktop
    packages = with pkgs; [
      firefox
    ];
  };
}
