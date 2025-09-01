{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        x13 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./.nixos/common.nix
            ./.nixos/hosts/x13/configuration.nix
          ];
        };
        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit nur;
            username = "nixos";
          };
          modules = [
            ./.nixos/common.nix
            ./.nixos/iso.nix
            home-manager.nixosModules.home-manager
            nur.modules.nixos.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                username = "nixos";
              };
              home-manager.users.nixos = import ./.nixos/home.nix;
            }
          ];
        };
      };
      homeConfigurations = {
        pharaok = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nur.overlays.default ];
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            username = "pharaok";
          };

          modules = [
            ./.nixos/home.nix
          ];
        };
      };
      packages.${system}.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
    };
}
