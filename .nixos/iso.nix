{
  pkgs,
  modulesPath,
  inputs,
  username,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"

    ./common.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  isoImage = {
    squashfsCompression = "lz4";
    contents = [
      # { source = ./..; target = "/home/${username}/.dotfiles/"; } FIX: doesn't work :(
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
