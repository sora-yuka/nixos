{
  lib,
  config,
  pkgs,
  ...
}:

let
  GTK_THEME_NAME = "WhiteSur";
  GTK_CURSOR_NAME = "GoogleDot-Blue";
  GTK_CURSOR_SIZE = 22;
  GTK_ICON_NAME = "Colloid";
  GTK_DARK = true;

  GTK_THEME_PACKAGE = pkgs.whitesur-gtk-theme;
  GTK_CURSOR_PACKAGE = pkgs.google-cursor;
  GTK_ICON_PACKAGE = pkgs.colloid-icon-theme;

  GTK_THEME = "${GTK_THEME_PACKAGE}/share/themes/${GTK_THEME_NAME}/gtk-4.0";
in
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = GTK_CURSOR_NAME;
    size = GTK_CURSOR_SIZE;
    package = GTK_CURSOR_PACKAGE;
  };

  gtk = {
    enable = true;

    theme = {
      name = GTK_THEME_NAME;
      package = GTK_THEME_PACKAGE;
    };
    iconTheme = {
      name = GTK_ICON_NAME;
      package = GTK_ICON_PACKAGE;
    };
    cursorTheme = {
      name = GTK_CURSOR_NAME;
      package = GTK_CURSOR_PACKAGE;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = GTK_DARK;
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${GTK_THEME}/assets";
    "gtk-4.0/gtk.css".source = "${GTK_THEME}/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${GTK_THEME}/gtk-dark.css";
  };

  # GTK4
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = GTK_THEME_NAME;
      color-scheme = lib.mkIf GTK_DARK "prefer-dark";
    };
  };
}
