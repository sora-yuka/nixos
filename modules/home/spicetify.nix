{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.hazy;

    enabledExtensions = with spicePkgs.extensions; [
      adblockify hidePodcasts shuffle
    ];

    enabledCustomApps = with spicePkgs.apps; [marketplace];
  };
}
