{ config, lib, pkgs, user, ... }:

{
  home.packages = [ pkgs.greetd ];
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "${user}";
      };
      default_session = initial_session;
    };
  };
}
