{ lib, pkgs, ... }:

{
  home.activation.githubkey = lib.hm.dag.entryAfter ["writeBoundary"] '' 
    key="$HOME/.ssh/id_ed25519_github"
    if [ ! -f "$key" ]; then
      mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -C "feelingjeez@gmail.com" -f "$key"
    fi
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      identityFile = "~/.ssh/id_ed25519_github";
      identitiesOnly = true;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.email = "feelingjeez@gmail.com";
      user.name = "sora-yuka";
      init.defaultBranch = "main";
    };
  };
}
