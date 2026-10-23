{ config, lib, ... }:

{
  options.custom.fastInstall.enable = 
    lib.mkEnableOption "build-time savings (no docs)";
  
  config = lib.mkIf config.custom.fastInstall.enable {
    documentation.nixos.enable = false;
    documentation.man.generateCaches = false;
    documentation.doc.enable = false;
    documentation.info.enable = false;
  };
}