{ lib, config, pkgs, ... }:

let
  GTK_THEME_NAME = "WhiteSur";
  GTK_CURSOR_NAME = "GoogleDot-Black";
  GTK_CURSOR_SIZE = 22;
  GTK_ICON_NAME = "Colloid";
  GTK_DARK = true;

  GTK_THEME_PACKAGE = pkgs.whitesur-gtk-theme;
  GTK_CURSOR_PACKAGE = pkgs.google-cursor;
  GTK_ICON_PACKAGE = pkgs.colloid-icon-theme;
in
{
  home-manager = {
    users.copa = {
      home = {
        pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          name = GTK_CURSOR_NAME;
          package = GTK_CURSOR_PACKAGE;
          size = GTK_CURSOR_SIZE;
        };

        sessionVariables = {
          GTK_THEME = GTK_THEME_NAME;
        };
      };

      gtk = {
        enable = true;

        theme = {
          name = GTK_THEME_NAME;
          package = GTK_THEME_PACKAGE;
        };

        iconTheme = {
          name = GTK_ICON_NAME;
          package = GTK_ICON_NAME;
        };

        cursorTheme = {
          name = GTK_CURSOR_NAME;
          package = GTK_CURSOR_PACKAGE;
        };

        gtk3.extraConfig.gtk-application-prefer-dark-theme = GTK_DARK;
      };

      # GTK4
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = GTK_THEME_NAME;
          color-scheme = lib.mkIf GTK_DARK "prefer-dark";
        };
      };
    };
  };
}
