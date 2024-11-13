# Enable + Install all necessary applications here
# To find available packages, see: [https://search.nixos.org/packages]

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    #--- System ---#
    # Audio
    # alsa-lib
    # alsa-plugins
    # alsa-utils

    # AD mount
    cifs-utils


    #--- Command line ---#
    git
    # htop
    # imagemagick7
    # kitty
    # mpv
    # mtr
    # p7zip
    # pciutils
    # playerctl
    plocate
    # ripgrep
    tmux
    # toybox # Bunch of common command line utils
    tree
    vim
    # xorg.xev
    # zip


    #--- Programming ---#
    # jdk22
    # kotlin
    # dotnet-sdk_8
    # dotnet-aspnetcore_8
    # php
    # # TODO: Add the rest

    # coreutils
    # cmakeWithGui
    # valgrind
    # gcc
    # gdb
    # ghc
    # glib
    # gnome.adwaita-icon-theme
    # gnumake
    # gtk3
    # haskell-language-server
    # just
    # manix
    # nil
    # nix-output-monitor
    # nixpkgs-fmt
    # python3 # See [https://nixos.wiki/wiki/Python]


    #--- Nvidia ---#
    # cudatoolkit


    #--- Desktop applications ---#
    # IDEs/Editors
    # scite
    # geany
    # lazarus

    # Browsers
    # firefox
    # tor-browser

    # Office
    # evince
    # okular
    # xournalpp

    # Media players
    # vlc

    # File explorer
    # gnome.nautilus

    # Other
    # arandr

    #--- Admin tools ---#
    neofetch
    # gparted
    nix-index # Enables `nix-locate`
    # nix-init # Easy Nix package generation from URLs
    lshw
  ];
}