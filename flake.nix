{
  description = "N1x system config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05"; # === "github:NixOS/nixpkgs/nixos-24.05"
    unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure nixpkgs versions match for the above
    };
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";

    stylix.url = "github:danth/stylix/6bbae4f85b891df2e6e48b649919420434088507";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{ self, nixpkgs, unstable, home-manager, flake-utils, stylix, catppuccin, poetry2nix, ... }:
    # flake-utils.lib.eachDefaultSystem (system:
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        upkgs = unstable.legacyPackages.${system};
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
                    catppuccin.homeManagerModules.catppuccin
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

        # TODO: To avoid running `home-manager switch` manually this can be added to the modules list above
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
