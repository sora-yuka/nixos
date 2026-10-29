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
    fastfetch.enable = true;
    quickshell.enable = true;
    nh.enable = true;
    nh.clean.enable = true;
  };

  xdg.configFile = {
    "niri".source = inputs.dotfiles + "/niri";
    "quickshell".source = inputs.dotfiles + "/quickshell";
    "fastfetch".source = inputs.dotfiles + "/fastfetch";
    "ghostty".source = inputs.dotfiles + "/ghostty";
    "zsh".source = inputs.dotfiles + "/zsh";
  };

  home.packages = with pkgs [
    # Nix tools
    nurl nixd nixfmt

    # Cli utilities
    zip unzip tree ripgrep fd
    jq fzf timg zsh-completions

    # Wayland essentials
    xwayland-satellite wl-clipboard
    cliphist grim slurp

    # Desktop essentials
    swaybg waypaper-engine
    kdePackages.dolphin pavucontrol
    playerctl vscode
  ] ++ lib.optionals config.custom.heavyApps.enable [
    postman telegram-desktop inputs.zen-browser.packages.${sys}.default
    inputs.helium.packages.${sys}.default ffmpeg-full cine
  ];
}
