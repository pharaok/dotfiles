{ config, pkgs, ... }:
{
  nix.settings = {
    allowed-users = [ "@wheel" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    obs-studio
    pavucontrol
    (python3.withPackages (
      ps: with ps; [
        numpy
        matplotlib
        pandas
        requests
      ]
    ))
    unzip
    usbutils
    wget
    xclip
    zathura
    zip
  ];
}
