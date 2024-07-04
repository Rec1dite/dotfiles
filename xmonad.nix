{ config, pkgs, ... }:

{
  imports = [];

  services.dbus = {
    enable = true;
    # packages = [ pkgs.gnome3.dconf ];
    packages = [];
  };

  # (Also configured directly in configuration.nix)
  services.xserver = {
    enable = true;

    displayManager.defaultSession = "none+xmonad";

    # Enable XMonad
    windowManager.xmonad = {
      enable = true;
      enableConfiguredRecompile = true;
      enableContribAndExtras = true;

      extraPackages = haskpkgs: [
        haskpkgs.dbus
        haskpkgs.monad-logger
        haskpkgs.xmonad-contrib
      ];

      config = builtins.readFile ./config/xmonad/xmonad.hs;

      # Redefine CapsLock behaviour
      # xkbOptions = "caps:ctrl_modifier";

      # ghcArgs = [
      #   "-hidir /tmp"		# Place interface files in /tmp so GHC doesn't try to write them to the Nix store
      #   "-odir /tmp"		# Place object files in /tmp so GHC doesn't try to write them to the Nix store
      #   "-i${xmonad-contexts}"	# Tell GHC to search in the respective Nix store path for the module
      # ];
    };

  };

  # Define XMonad config
  # services.xserver.windowManager.xmonad.config = builtins.readFile /home/rec1dite/.config/xmonad/xmonad.hs;

  # inputs.xmonad-contexts = {
  #   url = "github:Procrat/xmonad-contexts";
  #   flake = false;
  # };

}
