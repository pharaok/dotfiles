{pkgs, ...}: {
  nix.settings = {
    allowed-users = ["@wheel"];
    experimental-features = ["nix-command" "flakes"];
  };

  services.picom.enable = true;
  services.xserver = {
    enable = true;

    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages:
        with python3Packages; [
          qtile-extras
        ];
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
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
