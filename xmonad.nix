{ config, pkgs, ... }:

{
  imports = [];

  #=============== DBUS ==============#
  services.dbus = {
    enable = true;
    # packages = [ pkgs.gnome3.dconf ];
    packages = [];
  };

  # (Also configured directly in configuration.nix)
  services.xserver = {
    enable = true;

    #=============== XMONAD ==============#
    # Enable XMonad (Config handled in home.nix)
    windowManager.xmonad = {
      enable = true;
      enableConfiguredRecompile = true;
      enableContribAndExtras = true;
    };
  };

  #=============== DISPLAY MANAGER ==============#
  services.displayManager = {
    defaultSession = "none+xmonad";

    sddm = {
      enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };
  };
}
