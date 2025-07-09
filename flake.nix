{
  description = "N1x system config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11"; # === "github:NixOS/nixpkgs/nixos-24.11"
    unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure nixpkgs versions match for the above
    };
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{ self, nixpkgs, unstable, home-manager, flake-utils, stylix, catppuccin, poetry2nix, ... }:
    # flake-utils.lib.eachDefaultSystem (system:
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        # See [https://discourse.nixos.org/t/allow-insecure-packages-in-flake-nix/34655/2]
        # upkgs = unstable.legacyPackages.${system};
        upkgs = (import unstable {
          inherit system;
          config = { permittedInsecurePackages = [ "deskflow-1.19.0" ]; };
        });

        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
      in
      {
        nixosConfigurations.n1x = nixpkgs.lib.nixosSystem {
          inherit system;
          # See [https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules]
          specialArgs = { inherit upkgs home-manager mkPoetryApplication; };
          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.rec1dite = {
                  imports = [
                    ./home.nix
                    catppuccin.homeModules.catppuccin
                  ];
                };
                # extraSpecialArgs = { inherit pkgs; };
              };
            }

            stylix.nixosModules.stylix ./configuration.nix
            # { _module.args = { inherit inputs; }; }

            catppuccin.nixosModules.catppuccin
          ];
        };

        # ALT: Uses `home-manager switch` to update home-manager confs, instead of running alongside `nixos-rebuild switch`
        # See [https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager]
        # homeConfigurations = {
        #   rec1dite = home-manager.lib.homeManagerConfiguration {
        #     inherit pkgs;
        #     modules = [
        #       ./home.nix
        #       stylix.homeManagerModules.stylix
        #     ];
        #   };
        # };
      };
      # );
}
