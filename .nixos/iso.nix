{
  lib,
  config,
  pkgs,
  modulesPath,
  username,
  nur,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"

    ./common.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  isoImage = {
    squashfsCompression = "lz4";
  };

  networking.networkmanager.enable = true;
  networking.hostName = "nixos-live";
  # networking.interfaces.enp1s0.useDHCP = true;
  # networking.useHostResolvConf = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    nur.overlays.default
  ];

  # FIX: chown does not chowning
  system.activationScripts.copyDotfiles.text = ''
    mkdir -p /home/${username}/.dotfiles
    cp -r ${./..}/. /home/${username}/.dotfiles/
    chown -R ${username}:${username} /home/${username}/.dotfiles
  '';
}
