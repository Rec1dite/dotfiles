{
  description = "Brightness controller for Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs = { self, nixpkgs, poetry2nix }: 
    let 

      system = "x86_64-linux";  # Adjust to your system architecture
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;

    in {
      apps.${system}.default = mkPoetryApplication {
        inherit system;

        src = pkgs.fetchFromGitHub {
          owner = "LordAmit";
          repo = "Brightness";
          rev = "master";
          # sha256 = "sha256-checksum-of-the-tarball"; # Use 'nix-prefetch-git' to get this
        };

        nativeBuildInputs = [
          pkgs.qt5.qtbase
          pkgs.qt5.qtdeclarative
          pkgs.qt5.qtmultimedia
          pkgs.qt5.qtnetwork
          pkgs.sip
        ];

        propagatedBuildInputs = [
          pkgs.pyqt5
        ];

      };
  };
}
