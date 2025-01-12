{ pkgs, ... }: {
  nix.settings = {
    allowed-users = [ "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.picom.enable = true;
  services.blueman.enable = true;
  services.xserver = {
    enable = true;

    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [ qtile-extras ];
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.libinput = {
    enable = true;
    mouse = { accelProfile = "flat"; };
    touchpad = {
      naturalScrolling = true;
    };
  };
  services.kanata = { 
    enable = true;
    keyboards = { default = { configFile = ../.config/kanata/kanata.kbd; }; };
  };


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    arandr
    baobab
    bat
    btop
    feh
    firefox
    gcc
    ghostty
    git
    home-manager
    htop
    neofetch
    neovim
    nixfmt-classic
    pavucontrol
    ripgrep
    rofi
    rustup
    unzip
    # wezterm
    wget
    xclip
    zathura
  ];

  programs.zsh.enable = true;
}
