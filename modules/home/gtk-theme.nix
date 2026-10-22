{ pkgs, config, ... }:

{
  gtk = {
    enable = true;

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
      cursor-theme = config.home.pointerCursor.name;
      cursor-size = config.home.pointerCursor.size;
    };
  };
}
