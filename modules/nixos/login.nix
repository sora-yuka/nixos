# Chose the login screen:
# custom.login.manager = "ly";      # Ly
# custom.login.manager = "gdm";     # GDM alone
# custom.login.manager = "qylock";  # SDDM + qylock theme

{ config, lib, ... }:

let
  cfg = config.custom.login;
in
{
  options.custom.login = {
    manager = lib.mkOption {
      type = lib.types.enum ["ly" "gdm" "qylock"];
      default = "qylock";
      description = ''
        "gdm": lightweight GDM.
        "qylock": SDDM on Wayland with a qylock theme.
      '';
    };

    qylockTheme = lib.mkOption {
      type = lib.types.str;
      default = "nier-automata";
      description = ''
        Only used when manager = "qylock". Available themes:
        Genshin; R1999_1; R1999_2; clockwork; dog-samurai; enfield; field; forest;
        girl-coffee; girl-pillow; last-of-us; man-bicycle; material-you-dark; material-you;
        minecraft; nier-automata; ninesols; ninja_gaiden; nothing; osu; osumania; pixel-coffee;
        pixel-cyberpunk; pixel-dusk-city; pixel-emerald; pixel-hollowknight; pixel-munchlux;
        pixel-sakura; pixel-skyscrapers; pixel-waterfall; star-rail; sword; terraria; windows-7;
        winter; women-umbrella; wuwa; pixel-rainyroom; pixel-night-city.
        (clockwork might not work)
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.manager == "ly") {
      services.displayManager.ly.enable = true;
    })

    (lib.mkIf (cfg.manager == "gdm") {
      services.displayManager.gdm.enable = true;
      services.displayManager.gdm.wayland = true;
    })

    (lib.mkIf (cfg.manager == "qylock") {
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      
      programs.qylock.enable = true;
      programs.qylock.theme = cfg.qylockTheme;
    })
  ];
}