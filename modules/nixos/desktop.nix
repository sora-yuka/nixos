{ pkgs, ... }:

{
  programs.dconf.enable = true;
  programs.niri.enable = true;
  services.displayManager.gdm.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true; alsa.enable = true; pulse.enable = true;
  };
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:shift_caps_toggle";
  };
  fonts.packages = with pkgs; [
    iosevka
    fira-code
    jetbrains-mono
    maple-mono.truetype
    maple-mono.NF  # NF stands for Nerd Font
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.meslo-lg
  ];
}
