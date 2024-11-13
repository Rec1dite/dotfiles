# Auto-reload the current NixOS configuration from master branch on Github
# Also configures pulling cached packages from local server

# See: [https://wiki.nixos.org/wiki/Binary_Cache#Using_a_binary_cache]
# and: [https://discourse.nixos.org/t/how-to-set-up-cachix-in-flake-based-nixos-config/31781]

{ pkgs, ... }: {

  # Automatic garbage collection + Nix store optimisation
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;

}