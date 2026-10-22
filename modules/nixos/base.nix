{ pkgs, lib, inputs, ... }:

let 
  sys = pkgs.stdenv.hostPlatform.system;
in
{
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Bishkek";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;

  # Only a minimal set of system-wide tools (for emergencies).
  environment.systemPackages = with pkgs; [git vim curl wget google-cursor]
    ++ (with pkgs.gst_all_1; [
      gstreamer gst-plugins-base gst-plugins-good
      gst-plugins-bad gst-plugins-ugly gst-libav
    ]);
   
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
    with pkgs.gst_all_1; [
      gstreamer gst-plugins-base gst-plugins-good
      gst-plugins-bad gst-plugins-ugly gst-libav
    ]
  );

  environment.pathsToLink = ["/share/zsh"];
}
