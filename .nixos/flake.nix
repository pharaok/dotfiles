{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:pharaok/dotfiles";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    dotfiles,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [./configuration.nix];
      };
      iso = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          username = "nixos";
        };
        modules = [
          ./iso.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit dotfiles;
              username = "nixos";
            };
            home-manager.users.nixos = import ./home.nix;
          }
        ];
      };
    };
    homeConfigurations = {
      pharaok = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit dotfiles;
          username = "pharaok";
        };
        modules = [./home.nix];
      };
    };
  };
}
