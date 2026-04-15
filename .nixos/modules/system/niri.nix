{ pkgs, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    # ags
    # waybar
    brightnessctl
    cava
    fuzzel # app launcher
    mako # notification daemon
    pulseaudioFull
    rose-pine-cursor
    rose-pine-gtk-theme
    swayidle
    swaylock
    swww # wallpaper daemon
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
  services.upower.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
