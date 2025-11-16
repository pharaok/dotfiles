{ pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    # ags
    brightnessctl
    fuzzel # app launcher
    mako # notification daemon
    rose-pine-cursor
    rose-pine-gtk-theme
    swaylock
    swww # wallpaper daemon
    waybar
    wl-clipboard
    xwayland-satellite
    yazi
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gtk"
          "gnome"
        ];
      };
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
