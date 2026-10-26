{ config, lib, pkgs, inputs, ... }:
let
  sys = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [../../modules/home];

  home.username = "copa";
  home.homeDirectory = "/home/copa";
  home.stateVersion = "26.05";

  programs = {
    ghostty.enable = true;
    yazi.enable = true;
    fastfetch.enable = true;
    quickshell.enable = true;
    nh = {  # nicer nixos-rebuild and garbage collector
      enable = true;
      clean.enable = true;
      flake = "/etc/nixos#workmachine";
    };
  };

  xdg.configFile = {
    "niri".source = inputs.dotfiles + "/niri";
    "quickshell".source = inputs.dotfiles + "/quickshell";
    "fastfetch".source = inputs.dotfiles + "/fastfetch";
    "ghostty".source = inputs.dotfiles + "/ghostty";
    "zsh".source = inputs.dotfiles + "/zsh";
  };

  home.packages = with pkgs; [
    # Nix tools
    nurl              # replaces nix-prefetch-github
    nixd              # language server
    nixfmt

    # CLI utilities
    zip
    unzip
    tree
    ripgrep
    fd
    jq
    fzf
    timg
    zsh-completions

    # Wayland essentials
    xwayland-satellite
    wl-clipboard
    cliphist
    grim
    slurp

    # Desktop essentials
    swaybg
    waypaper-engine
    nautilus
    pavucontrol
    playerctl
  ] ++ lib.optionals config.custom.heavyApps.enable [
    # Heavy / unfree apps (custom.heavyApps.enable)
    vscode
    postman
    telegram-desktop
    inputs.zen-browser.packages.${sys}.default
    inputs.helium.packages.${sys}.default
    ffmpeg-full
    mangohud
    devenv
    cine
  ];
}
