{ config, lib, pkgs, user, ... }:

{ 
  imports =
    # (import ../modules/editors) ++
    (import ../modules/programs) ++
    (import ../modules/services) ++
    (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      pavucontrol
      google-chrome
      remmina
      okular
      rsync
      unzip
      unrar
      git
      killall
      nano
      pciutils
      pipewire
      usbutils
      wget
      zsh
      alacritty
      vim
      rofi
      udiskie
      discord
      ffmpeg
      libreoffice
      greetd
    ];
    file.".config/wall".source = ../modules/themes/wall;
    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";         # or FiraCode Nerd Font Mono Medium
    };                                        # Cursor is declared under home.pointerCursor
  };
}
