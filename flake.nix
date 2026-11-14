{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:sora-yuka/config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.workmachine = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/workmachine
        inputs.qylock.nixosModules.default
      ];
    };

    # Slim variant for the first install.
    # After first boot: nixos-rebuild --flake /etc/nixos#workmachine
    nixosConfigurations.workmachine-lite =
      self.nixosConfigurations.workmachine.extendModules {
        modules = [{
          custom.fastInstall.enable = true;
          custom.login.manager = "ly";
          home-manager.users.copa.custom.heavyApps.enable = false;
        }];
      };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/laptop
        inputs.qylock.nixosModules.default
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
