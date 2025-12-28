{
  config,
  pkgs,
  lib,
  dotfiles,
  username,
  ...
}:
let
  dotfilesDir = "./.dotfiles";
in
{
  imports = [
    ./modules/home/niri.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  home.username = username;
  home.homeDirectory = "/home/${username}";

  xdg.enable = true;
  home.activation = {
    cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${dotfilesDir}" ]; then
        ${pkgs.git}/bin/git clone https://github.com/pharaok/dotfiles.git ${dotfilesDir} || true
      fi
    '';
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # slack
    cbonsai
    discord
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nur.repos.nltch.spotify-adblock
    pfetch
    pipes
    # winboat
    xournalpp
    zoom-us
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file =
    let
      exclude = path: type: !builtins.elem (builtins.baseNameOf path) [ "lazy-lock.json" ];
    in
    {
      "${config.xdg.configHome}" = {
        source = builtins.filterSource exclude ../.config;
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
  programs.zsh = {
    enable = true;
  };
  home.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
  };

  programs.starship.enable = true;
  programs.eza.enable = true;
  home.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    la = "eza -la";
  };
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color fg:#908caa,bg:#191724,hl:#ebbcba"
      "--color fg+:#e0def4,bg+:#26233a,hl+:#ebbcba"
      "--color border:#403d52,header:#31748f,gutter:#191724"
      "--color spinner:#f6c177,info:#9ccfd8"
      "--color pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
    ];
  };
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
    extraPackages = with pkgs; [
      ripgrep
      clang-tools
      eslint_d
      lua-language-server
      nixfmt-rfc-style
      prettierd
      stylua
      vim-language-server
      (python3.withPackages (
        ps: with ps; [
          pylsp-mypy
          python-lsp-black
          pyls-isort
          python-lsp-server
        ]
      ))
      texlab
      (texlive.withPackages (
        ps: with ps; [
          scheme-medium

          latexmk
          latexindent

          diagbox
          enumitem
          environ
          hanging
          minted
          pict2e
          pgfplots
          tcolorbox
          tikz-cd
          venndiagram

          framed
          lipsum
          tkz-euclide
          background
          upquote
          everypage

          amsmath
          # amssymb
          iftex
          yhmath
          derivative
          listings
          # mathrsfs
          # textcomp
          enumitem
          todonotes
          multirow
          ellipsis
          epigraph
          mathtools
          microtype
          xstring
          wrapfig
          tikz-cd
          isodate
          xcolor
          hyperref
          cleveref
          # amsthm
          thmtools
          mdframed
          xpatch
          fancyhdr
          # scrlayer-scrpage
          zref
          needspace
          nextpage
          substr
        ]
      ))
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
