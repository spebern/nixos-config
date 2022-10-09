{ pkgs, lib, user, ... }:

{
  imports =
    [(import ./hardware-configuration.nix)] ++
    [(import ../../modules/programs/games.nix)] ++
    [(import ../../modules/services/greetd.nix)] ++
    [(import ../../modules/desktop/sway/default.nix)] ++
    (import ../../modules/desktop/virtualisation) ++
    (import ../../modules/hardware);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    #initrd.kernelModules = [ "amdgpu" ];       # Video drivers
    
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };

  services = {
    blueman.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
          sha256 = "1kwqn1xr96kvrlbjd14m304g2finc5f5ljvnklg6fs5k4avrvmn4";
        };}
      );
    })
  ];
}
