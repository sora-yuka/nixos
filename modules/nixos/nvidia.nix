# Proprietary NVIDIA driver, configured through a small option set so
# the module itself stays generic and the host only supplies hardware facts.

# Install NVIDIA driver. By default, it would download
# latest driver for newer Nvidia GPU (Turing or newer).
# custom.nvidia.enable = true;

# Hybrid machine (Intel iGPU + NVIDIA dGPU) -> Set both bus Ids.
# custom.nvidia.prime.intelBusId  = "PCI:0:2:0";
# custom.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

# Nvidia-only machine -> skip `custom.nvidia.prime.` option.

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.nvidia;
  hybrid = cfg.prime.intelBusId != null && cfg.prime.nvidiaBusId != null;
in
{
  options.custom.nvidia = {
    enable = lib.mkEnableOption "The proprietary NVIDIA driver";

    open = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use NVIDIA's open kernel modules. Supported on Turing or newer
        (GTX 16XX / RTX 20XX) and later. Set to false for older GPUs.
      '';
    };

    package = lib.mkOption {
      type = lib.types.str;
      default = "stable";
      example = "legacy_580";
      description = ''
        Attribute name inside `boot.kernelPackages.nvidiaPackages`.
      '';
    };

    prime = {
      intelBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "PCI:0:2:0";
      };
      nvidiaBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "PCI:1:0:0";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.prime.intelBusId == null) == (cfg.prime.nvidiaBusId == null);
        message = "custom.nvidia.prime: set both intelBusId and nvidiaBusId, or neither";
      }
    ];

    # Required even on Wayland.
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      open = cfg.open;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.package};

      # Fixes black/brocker screen after suspend.
      powerManagement.enable = true;
      powerManagement.finegrained = hybrid && cfg.open;

      prime = lib.mkIf hybrid {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;
      };
    };

    # NVIDIA ONLY!
    # Make everything use NVIDIA GPU. Must NOT be set
    # on hybrid, or it would force every app onto dGPU.
    environment.sessionVariables = lib.mkIf (!hybrid) {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
    hardware.graphics.extraPackages = lib.mkIf (!hybrid) [pkgs.nvidia-vaapi-driver];
  };
}
