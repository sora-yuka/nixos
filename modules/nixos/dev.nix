{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
}
