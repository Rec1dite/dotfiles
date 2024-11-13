# Main entry point for the NixOS configuration.
# For available options, see: [https://search.nixos.org/options]

# For a crash course in the Nix language, see: [https://learnxinyminutes.com/docs/nix]

# You can verify the integrity of the configuration without applying it as follows:
#   $ nixos-rebuild dry-build -I nixos-config=./configuration.nix


# To apply the configuration, run:
#   $ sudo nixos-rebuild switch -I nixos-config=./configuration.nix
#
# (If the configuration is symlinked to /etc/nixos/configuration.nix, you can omit the -I option)


# For packaging the system into a .iso image:
# See: [https://mynixos.com/help/nixos-generate]
# and: [https://github.com/nix-community/nixos-generators]
#
# To generate a .iso image, run:
#   $ sudo nixos-generate -f iso -c ./configuration.nix
# For flake-based configurations, run:
#   $ sudo nixos-generate -f iso --flake .#labpc


{ lib, pkgs, ... }: {
  # Import settings from the other modules
  imports = [
    ./reload.nix
    # ./desktop.nix
    ./pam.nix
    ./mnt-ad.nix
    # ./mnt-home.nix
    ./apps.nix
  ];


  #--- System config ---#
  system.stateVersion = "24.05"; # LEAVE AS-IS, NEVER CHANGE
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking = {
    hostName = "labpc";
    # useDHCP = true;

    networkmanager.enable = true;
  };

  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";


  #--- Techteam accounts ---#
  # Create local 'techteam' superuser
  users.users.techteam = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "5bae908c^";
    extraGroups = [ "wheel" "techteam" ];
  };

  # Allow members of 'techteam' group to execute any command
  security.sudo.extraRules = [
    {
      groups = [ "techteam" ];
      commands = [ "ALL" ];
    }
  ];


  #--- Convenience settings ---#
  environment.variables = {
    EDITOR = "vim";
    TERM = "xterm-256color";
  };
}