{ config, lib, pkgs, ... }:
let
  cfg = config.system.defaults.NSGlobalDomain;

  isRgbDecimal = x: all (a: hasAttr a x && 0 <= getAttr a x && getAttr a x <= 1) [ "Red" "Green" "Blue" ];

  rgbDecimal = mkOptionType {
    name = "rgbDecimal";
    description = "rgbDecimal";
    check = isRgbDecimal;
    merge = options.mergeOneOption;
  };

  appleSystemColors = {
    Graphite = {
      accent = (-1);
      highlight = "0.847059 0.847059 0.862745 Graphite";
    };
    Red = {
      accent = 0;
      highlight = "1.000000 0.733333 0.721569 Red";
    };
    Orange = {
      accent = 1;
      highlight = "1.000000 0.874510 0.701961 Orange";
    };
    Yellow = {
      accent = 2;
      highlight = "1.000000 0.937255 0.690196 Yellow";
    };
    Green = {
      accent = 3;
      highlight = "0.752941 0.964706 0.678431 Green";
    };
    Blue = {
      accent = 4;
      highlight = "0.698039 0.843137 1.000000 Blue";
    };
    Purple = {
      accent = 5;
      highlight = "0.968627 0.831373 1.000000 Purple";
    };
    Pink = {
      accent = 6;
      highlight = "1.000000 0.749020 0.823529 Pink";
    };
  };

  coerceAppleAccentColor = x:
    if x == null
    then null
    else attrByPath [ x "accent" ] null appleSystemColors;

  coerceAppleHighlightColor = x:
    if x == null then
      (attrByPath
        [ (toString cfg.AppleAccentColor) ]
        null
        ((mapAttrs' (name: value: nameValuePair (toString value.accent) value.highlight))
          appleSystemColors))
    else with builtins; "${toString x.Red} ${toString x.Green} ${toString x.Blue} Other";

in
{

  system.defaults.NSGlobalDomain.AppleAccentColor = mkOption {
    type = types.coercedTo
      (types.nullOr (types.enum (builtins.attrNames appleSystemColors)))
      coerceAppleAccentColor
      (types.nullOr types.int);
    default = null;
    description = ''
      Configures the color of native controls.
      Catalina: The default is Blue
      Big Sur: The default is multicolor
    '';
  };

  system.defaults.NSGlobalDomain.AppleHighlightColor = mkOption {
    type = types.coercedTo
      (types.nullOr rgbDecimal)
      coerceAppleHighlightColor
      (types.nullOr types.string);
    default = null;
    description = ''
      Configures the highlight color for text, files, etc.
      Catalina: The default is Blue
      Big Sur: The default is multicolor
         
      If left unset, AppleHighlightColor will match AppleAccentColor
    '';

  };
}
