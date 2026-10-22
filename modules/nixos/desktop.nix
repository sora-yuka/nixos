{ pkgs, config, ... }:

{
  programs.dconf.enable = true;
  programs.niri.enable = true;
  # services.displayManager.gdm.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings.Theme = {
    CursorTheme = "GoogleDot-Black";
    CursorSize = 22;
  };
  security.polkit.enable = true;
  services.pipewire = {
    enable = true; alsa.enable = true; pulse.enable = true;
  };
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:shift_caps_toggle";
  };
  programs.qylock = {
    enable = true;
    theme = "last-of-us";
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
