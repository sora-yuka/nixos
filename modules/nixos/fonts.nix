{ pkgs, ... }:
let
  apple-sf-fonts = pkgs.stdenvNoCC.mkDerivation {
    name = "apple-san-francisco-fonts";

    src = pkgs.fetchFromGitHub {
      owner = "chris-short";
      repo = "apple-san-francisco-pro-fonts";
      rev = "91889afd7aad1e13b7d73e46d19522d8d0a90068";
      hash = "sha256-xdEd7N3c3NMs0Rrw8iDZVcGw14KBM+uFLKjDGsFuzRQ=";
    };

    installPhase = ''
      runHook preInstall
      find . -iname '*.otf' -exec install -Dm644 {} -t $out/share/fonts/opentype \;
      find . -iname '*.ttf' -exec install -Dm644 {} -t $out/share/fonts/truetype \;
      runHook postInstall
    '';
  };
in
{
  fonts.packages = [ apple-sf-fonts ];
}

