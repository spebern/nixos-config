{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh_nix";
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = ''
        autoload -U promptinit; promptinit
      '';
    };
  };
}
