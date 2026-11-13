{ pkgs, config, inputs, ... }:

{
  imports = [
    inputs.inir.nixosModules.inir
    ./fonts.nix
  ];

  programs.dconf.enable = true;
  programs.niri.enable = true;
  programs.inir = {
    enable = true;
    service.enable = true;
    extraPackages = [ config.programs.niri.package ];
  };
  security.polkit.enable = true;
  services.pipewire = {
    enable = true; alsa.enable = true; pulse.enable = true;
  };
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:shift_caps_toggle";
  };
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    maple-mono.truetype
    corefonts
    inter
    maple-mono.NF  # NF stands for Nerd Font
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.meslo-lg
  ];
  systemd.tmpfiles.rules = [
    "L+ /usr/share/fonts - - - - /run/current-system/sw/share/X11/fonts"
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gnome xdg-desktop-portal-gtk];
    config.niri.default = ["gnome" "gtk"];
  };
}
