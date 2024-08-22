{ pkgs, ... }: {
  nix.settings = {
    allowed-users = [ "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

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
    touchpad = { sendEventsMode = "disabled-on-external-mouse"; };
  };
  services.kanata = { # TODO
    enable = true;
    keyboards = { default = { configFile = ../.config/kanata/kanata.kbd; }; };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    arandr
    bat
    btop
    feh
    firefox
    gcc
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
    wezterm
    wget
    zathura
  ];

  programs.zsh.enable = true;
}
