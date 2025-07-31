#@# e6985acc83420892507ba248871d0a92

{ pkgs, upkgs, ... }: { environment.systemPackages = with pkgs; [ #@
  (import (fetchFromGitHub {                                      #@
    owner = "rec1dite"; repo = "annix"; rev = "master";           #@
    hash = "sha256-JCFZOl+3uS5vTA8NNw3HDGdnSoQrtO2/YCLcWtZ0T7I="; #@
  }) { inherit pkgs; configs = {                                  #@
    ANNIX_FILE = "/home/rec1dite/.dotfiles/an.nix"; };            #@
  })                                                              #@
  # git rev-parse --show-toplevel

  #== System utils ==#
  alsa-lib
  alsa-plugins
  alsa-utils
  bc
  bottom
  brightnessctl
  cifs-utils
  coreutils
  exiftool
  eza
  file
  git
  gparted
  htop-vim
  kitty
  tty-clock
  lshw #@

  mpv
  mtr
  neofetch
  nix-index # Enables `nix-locate`
  p7zip
  pciutils
  playerctl
  ripgrep
  sxiv
  tree
  toybox # Bunch of command line utils
  unzip
  wget
  xmonad-log
  xorg.xev
  zip
  # libsForQt5.qtstyleplugin-kvantum
  libsForQt5.qt5ct

  #== Programming ==#
  vim
  upkgs.devenv
  upkgs.zed-editor
  haskell-language-server
  ghc
  manix
  just
  nix-output-monitor
  nil
  nixpkgs-fmt
  nix-init # Easy Nix package generation from URLs
  upkgs.devbox
  adwaita-icon-theme
  gtk3
  glib
  gsettings-desktop-schemas
  typst
  gsettings-qt
  gnome.nixos-gsettings-overrides
  processing
  cargo
  rustc
  # (arrayfire.override { cudaSupport = true; } )

  # For disabling middle click paste
  xbindkeys
  xdotool
  xsel

  #== System config ==#
  arandr
  nitrogen

  #== Nvidia ==#
  cudatoolkit

  #== Compilation ==#
  gcc
  gnumake
  python3 # See [https://nixos.wiki/wiki/Python]
  upkgs.uv

  #== Navigation ==#
  dmenu
  nautilus
  ranger
  rofi
  haskellPackages.greenclip

  #== Desktop applications ==#
  (blender.override { cudaSupport = true; }) #@
  cava
  firefox
  chromium
  tor-browser
  keepass
  imagemagick
  obs-studio
  obsidian
  okular
  xournalpp
  youtube-music
  vlc
  yt-dlp
  ffmpeg_7
  vesktop
  transmission_4-gtk
  ecryptfs
  #- test
  #- go-mtpfs
  mtpfs
  pipx
  traceroute
  dnsmasq
  ventoy
  progress
  rpi-imager
  nmap
  #- cope
  upkgs.deskflow
  nixfmt-rfc-style
  #- wl-kbptr
  #- teams
  #- postgresql
  flyway
  zap
  dig
  tcpdump
  neovim
  screenkey
  postman

  #== New ==#
  mongosh
  mongodb-compass
  #@+^

]; } #@