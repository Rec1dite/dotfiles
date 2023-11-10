{
  description = "N1x system config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05"; # === "github:NixOS/nixpkgs/nixos-23.05"
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure nixpkgs versions match for the above
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Create overlay to allow unfree packages
      # allowUnfreeOverlay = final: prev: {
      #   nixpkgs.config = prev.nixpkgs.config // {
      #     allowUnfree = true;
      #   };
      # };

      # Apply overlay to packages
      # pkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [ allowUnfreeOverlay ];
      # };

    in {
      # nixpkgs.config.allowUnfree = true;

      nixosConfigurations = {
        n1x = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };

      homeConfigurations = {
        rec1dite = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
  };
}
