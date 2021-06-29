{ config, lib, ... }:
with lib;
let
  cfg = config.system.defaults.wallpaper;
in
{
  options = {
    system.defaults.wallpaper.file = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Wallpaper image path
      '';
    };
  };

  config = mkIf (cfg.file != null) {
    system.activationScripts.extraUserActivation.text = ''
      echo "setting wallpaper..."
      sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '${cfg.file}'";
      killall Dock
    '';
  };

}
