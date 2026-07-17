{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.xdph.settings.screencopy;
in {
  options = {
    services.xdph.settings.screencopy = {
      maxFps = mkOption {
        type = types.int;
        default = 120;
        description = "Maximum fps of a screensharing session. 0 means no limit.";
      };

      allowTokenByDefault = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, will tick the “Allow restore token” box by default.";
      };

      customPickerBinary = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/path/to/custom/binary";
        description = "If non-empty, will use that binary as your share picker. Please note that it has to conform to the stdout selection layout of hyprland-share-picker.";
      };

      forceShm = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, will skip DMA-BUF and always use SHM for screensharing. SHM is slower than DMA-BUF (especially at high resolutions) but can work around DMA-BUF allocation failures on multi-GPU systems.";
      };
    };
  };

  config = {
    xdg.configFile."hypr/xdph.conf".text = ''
      screencopy {
        max_fps = ${toString cfg.maxFps}
        allow_token_by_default = ${boolToString cfg.allowTokenByDefault}
        force_shm = ${boolToString cfg.forceShm}
        ${optionalString (cfg.customPickerBinary != null) "custom_picker_binary = ${cfg.customPickerBinary}"}
      }
    '';
  };
}
