{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  # configure options
  programs.noctalia-shell = {
    enable = true;
    colors = {
      mError = "#eb6f92";
      mOnError = "#191724";
      mOnPrimary = "#191724";
      mOnSecondary = "#191724";
      mOnSurface = "#e0def4";
      mOnSurfaceVariant = "#908caa";
      mOnTertiary = "#191724";
      mOnHover = "#e0def4";
      mOutline = "#6e6a86";
      mPrimary = "#c4a7e7";
      mSecondary = "#ebbcba";
      mShadow = "#191724";
      mSurface = "#191724";
      mHover = "#26233a";
      mSurfaceVariant = "#1f1d2e";
      mTertiary = "#9ccfd8";
    };
    settings = {
      # configure noctalia here
      bar = {
        density = "default";
        position = "left";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        # avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Cairo, Egypt";
      };
    };
    # this may also be a string or a path to a JSON file.
  };
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "/home/pharaok/.dotfiles/.config/niri/rose_pine_contourline.png";
    };
  };
}
