{
  description = "N1x system config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05"; # === "github:NixOS/nixpkgs/nixos-23.05"
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure nixpkgs versions match for the above
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      nixlib = nixpkgs.lib;
      hmlib = home-manager.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosConfigurations = {
      n1x = nixlib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };
    homeConfigurations = {
      rec1dite = hmlib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}
