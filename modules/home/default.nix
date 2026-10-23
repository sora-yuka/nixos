{ lib, ... }:

{
  imports = [
    ./git.nix ./gtk-theme.nix
    ./spicetify.nix ./terminal.nix ./vim.nix
  ];

  options.custom.heavyApps.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Big or unfree desktop apps. Disable for quick first install, enable later.
    '';
  };
}
