{ config, pkgs, ... }:
{
  nix.settings = {
    allowed-users = [ "@wheel" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.picom.enable = true;
  services.blueman.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver = {
    enable = true;

    # windowManager.qtile = {
    #   enable = true;
    #   extraPackages = python3Packages: with python3Packages; [ qtile-extras ];
    # };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    arandr
    baobab
    fastfetch
    feh
    ffmpeg
    gcc
    ghostty
    git
    gnumake
    gparted
    home-manager
    htop
    killall
    neofetch
    neovim
    pavucontrol
    # pnpm
    (python3.withPackages (
      ps: with ps; [
        numpy
        pandas
        requests
      ]
    ))
    # rofi
    # rustup
    unzip
    # wezterm
    wget
    xclip
    zathura
    zip
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  networking.firewall = {
    trustedInterfaces = [ "virbr0" ];
  };
}
