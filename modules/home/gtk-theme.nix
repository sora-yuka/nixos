{ pkgs, config, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };

    iconTheme = {
      name = "Colloid";
      package = pkgs.colloid-icon-theme;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.pointerCursor = {
    enable = true;
    name = "GoogleDot-Black";
    package = pkgs.google-cursor;
    size = 22;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "WhiteSur-Dark";
      cursor-theme = config.home.pointerCursor.name;
      cursor-size = config.home.pointerCursor.size;
    };
    "org/gnome/shell/extensions/user-theme".name = "WhiteSur-Dark";
  };
}
