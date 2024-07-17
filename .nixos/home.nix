{
  config,
  pkgs,
  lib,
  dotfiles,
  username,
  ...
}: let
  dotfilesDir = "./.dotfiles";
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.activation = {
    cloneDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${dotfilesDir}" ]; then
        ${pkgs.git}/bin/git clone https://github.com/pharaok/dotfiles.git ${dotfilesDir} || true
      fi
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import ./spotify-adblock.nix)
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override {fonts = ["FiraCode" "NerdFontsSymbolsOnly"];})
    spotify-adblock

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "${config.xdg.configHome}" = {
      source =
        if builtins.stringLength (builtins.getEnv "HOME_MANAGER_DEV") > 0
        then ../.config
        else "${dotfiles}/.config";
      recursive = true;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pharaok/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
