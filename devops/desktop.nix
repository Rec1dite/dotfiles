# Configure the desktop environment here
# See: [https://wiki.nixos.org/wiki/GNOME]

{ pkgs, ... }: {

  #--- Enable Gnome + display manager ---#
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  #--- Exclude unwanted bundled packages ---#
  environment.gnome.excludePackages = (with pkgs; [
    # pkgs.*
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    # gnome.pkgs.*
    epiphany # Web browser
    geary
  ]);

  #--- Custom dconf settings ---#
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      lockAll = true; # Prevent overriding
      settings = {
        # Add settings here
      };
    ];
  };

  #--- Additional packages ---#
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
    sysprof
  ]

  services.sysprof.enable = true; # System profiling

}