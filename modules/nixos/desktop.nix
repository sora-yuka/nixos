{ pkgs, config, ... }:

{
  programs.dconf.enable = true;
  programs.niri.enable = true;
  #services.displayManager.gdm.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
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
    theme = "enfield";
    # List of available themes:
    # Genshin; R1999_1; R1999_2; clockwork; dog-samurai; enfield; field; forest;
    # girl-coffee; girl-pillow; last-of-us, man-bicycle; material-you-dark; material-you;
    # minecraft; nier-automata; ninesols; ninja_gaiden; nothing; osu; osumania; pixel-coffee;
    # pixel-cyberpunk; pixel-dusk-city; pixel-emerald; pixel-hollowknight; pixel-munchlux; 
    # pixel-sakura; pixel-skyscrapers; pixel-waterfall; star-rail; sword; terraria; windows-7;
    # winter; women-umbrella; wuwa; pixel-rainyroom; pixel-night-city.
    # clockwork theme might not work
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
