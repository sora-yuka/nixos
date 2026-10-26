{ pkgs, inputs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    fastSyntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
   ];

    shellAliases = {
      nix-update = "nh os switch /etc/nixos -H workmachine";
      refresh-flake-lock = "nix flake update --flake /etc/nixos";
      nix-dev = "nix develop --command zsh";

      gi = "git init";
      gr = "git remote add origin";
      ga = "git add";
      gc = "git commit -m";
      gps = "git push origin main";
      gpl = "git pull origin main";

      ui = "uv init --no-package";
      ur = "uv run python";
      ua = "uv add";
      um = "uv remove";
      us = "uv sync";
      ut = "uv tree";
    };

    initContent = ''
      eval "$(devenv hook zsh)"  

      if [[ "$TERM_PROGRAM" == ghostty ]]; then
        eval "fastfetch"
      fi

      unsetopt nomatch

      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey '^[[3;5~' kill-word
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.readFile (inputs.dotfiles + "/zsh/config.json"));
  };
}
