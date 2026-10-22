{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos  # common nixos configs
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "workmachine";

  programs.zsh.enable = true;

  users.users.copa = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "backup";
    users.copa = import ./home.nix;
  };

  custom.nvidia = {
    enable = true;
    open = false;
    package = "legacy_580";
  };

  system.stateVersion = "26.05";
}
