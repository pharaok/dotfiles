{ pkgs, modulesPath, inputs, username, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    allowed-users = ["@wheel"];
    experimental-features = ["nix-command" "flakes"];
  };

  isoImage = {
    squashfsCompression = "lz4";
    makeEfiBootable = true;
    makeUsbBootable = true;
    contents = [
      # { source = ./..; target = "/home/${username}/.dotfiles/"; }
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  services.picom.enable = true;
  services.xserver = {
    enable = true;

    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [ 
        qtile-extras 
      ];
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

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
}
