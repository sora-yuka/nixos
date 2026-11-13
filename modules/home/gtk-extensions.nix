{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    user-themes
    blur-my-shell
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    enabled-extensions = with pkgs.gnomeExtensions; [
      user-themes.extensionUuid
      blur-my-shell.extensionUuid
    ];
  };
}
