{ pkgs, ... }:

let
  yorhaTheme = pkgs.fetchFromGitHub {
    owner = "OliveThePuffin";
    repo = "yorha-grub-theme";
    rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";

    # You can get hash using nix-prefetch-github:
    # nix-prefetch-github [owner] [repo] --rev [rev]
    # Or use nurl: url https://github.com/theme/url
    hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
  };
in
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      gfxmodeEfi = "1920x1080,auto";
      gfxpayloadEfi = "keep";
      theme = "${yorhaTheme}/yorha-1920x1080";
    };
    timeout = 7;
  };
}
