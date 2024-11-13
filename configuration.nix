# See docs [https://nixos.org/manual/nixos/stable/options]
# See [configuration.nix(5)]
# See [$ nixos-help]

{ config, lib, stdenv, pkgs, upkgs, home-manager, mkPoetryApplication, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./xmonad.nix
    ];

  #=============== BOOT ==============#
  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10; # Limit the number of generations in /boot/loader/entries
  };
  # boot.loader.timeout = 1; # As per [https://discourse.nixos.org/t/how-to-add-bootentry-booting-straight-into-latest-generation/33507/2]
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];


  #=============== NIX ==============#
  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "rec1dite" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Leave as-is
  system.stateVersion = "24.05";

  # Automatic garbage collection + optimisation
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;

  system.autoUpgrade = {
    enable = true;
    # flake = inputs.self.outPath;
    # flags = [
    #   "--update-input"
    #   "nixpkgs"
    #   "-L"
    # ];
    # dates = "02:00";
    # randomizedDelaySec = "45min";
  };

  #=============== SYSTEM ==============#
  # Enable upower
  services.upower.enable = true;
  systemd.services.upower.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      # SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
      # USB_BLACKLIST_PHONE = 1;
    };
  };

  #=============== NETWORKING ==============#
  networking.hostName = "n1x"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";


  #=============== XORG ==============#
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    xkb = {
      layout = "za";
      variant = "";
    };

    # Set keyrepeat values (eqiv. to `xset r rate 225 60`)
    autoRepeatDelay = 225;
    autoRepeatInterval = 60;

    exportConfiguration = true; # Creates a symlink at /etc/X11/xorg.conf pointing to the main config
  };

  # Configure input devices
  services.libinput = {
    enable = true;

    mouse = {};
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };


  #=============== AUDIO + BLUETOOTH ==============#
  # Enable audio via PulseAudio
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true; # Enable compatibility with 32-bit apps
    extraConfig = ''
      autospawn = yes
    '';
  };
  nixpkgs.config.pulseaudio = true;

  # If pulseaudio fails to start, try:
  # $ pulseaudio --kill
  # $ pulseaudio --start

  # TODO: Fixes
  # See [https://www.reddit.com/r/ASUS/comments/mfokva/asus_strix_scar_17_g733qs_and_linux]
  # and [https://nixos.wiki/wiki/ALSA]
  # and [$ pactl list sinks]

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # FOR HOME MANAGER:
  # # Enable headset audio controls (play/pause etc.)
  # systemd.user.services.mpris-proxy = {
  #   enable = true;
  #   description = "Mpris proxy";
  #   after = [ "network.target" "sound.target" ];
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.ExecStart = "${pkgs.bluez}";
  # };


  #=============== FONTS ==============#
  # Install fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];


  #=============== GPU ==============#
  # See [https://nixos.wiki/wiki/Nvidia#Modifying_NixOS_Configuration]
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load Nvidia driver for Xorg (& Wayland)
  services.xserver.videoDrivers = [ "nvidia" ];

  # Set up Nvidia drivers
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # Use Nvidia open source kernel module
    open = true;

    # Enable Nvidia settings menu
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";

      #===== GPU MODES =====#
      # > ONLY ONE OF THESE MAY BE ENABLED AT A TIME!!

      #-- Offload mode --#
      # Better battery saving:
      # > Uses integrated graphics for most tasks, only uses GPU when explicitly needed
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      #-- Sync mode --#
      # Better performance:
      # > Uses GPU for all tasks
      # sync = { enable = true; };

      #-- Reverse Sync mode --#
      # EXPERIMENTAL!!
      # See [https://github.com/NixOS/nixpkgs/pull/165188]
      # > Uses integrated graphics by default, but offloads occasionally to GPU
      # reverseSync = { enable = true; };
      # allowExternalGpu = false;

    };
  };

  #=============== ASUS LINUX UTILS ==============#
  # See [https://asus-linux.org/guides/nixos]
  # Set up Supergfxctl
  services.supergfxd.enable = true;

  services.asusd = {
    enable = true;
    enableUserService = false;
    # auraConfig
  };


  #=============== USER ACCOUNTS ==============#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rec1dite = {
    isNormalUser = true;
    description = "Rec1dite";
    extraGroups = [ "networkmanager" "wheel" "audio" "mlocate" "docker" ];
    packages = with pkgs; [];
  };


  #=============== SYSTEM SOFTARE ==============#
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #== System utils ==#
    alsa-lib
    alsa-plugins
    alsa-utils
    bottom
    brightnessctl
    cifs-utils
    coreutils
    exiftool
    eza
    file
    git
    gparted
    htop
    kitty
    lshw
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
    gnome.adwaita-icon-theme
    gtk3
    glib
    gsettings-desktop-schemas
    # (arrayfire.override { cudaSupport = true; } )

    # For disabling middle click paste
    xbindkeys
    xdotool
    xsel

    #== System config ==#
    arandr
    nitrogen
    (catppuccin-sddm.override {
      flavor = "mocha";
      font  = "Fira Code";
      fontSize = "9";
      # background = "${./wallpaper.png}";
      loginBackground = false;
    })

    #== Nvidia ==#
    cudatoolkit

    #== Compilation ==#
    gcc
    gnumake
    python3 # See [https://nixos.wiki/wiki/Python]
    upkgs.uv

    #== Navigation ==#
    dmenu
    gnome.nautilus
    ranger
    rofi
    haskellPackages.greenclip

    #== Desktop applications ==#
    (blender.override { cudaSupport = true; })
    cava
    firefox
    chromium
    tor-browser
    keepass
    imagemagick7
    neofetch
    obs-studio
    obsidian
    okular
    xournalpp
    youtube-music
    vlc
    yt-dlp
    ffmpeg_7
    vesktop
    transmission-gtk

    # See: [https://nixos.org/manual/nixpkgs/stable/#chap-overrides]
    (tauon.overrideAttrs (final: prev: {
      # themeSrc = fetchFromGitHub {
      #   owner = "Achardir";
      #   repo = "catppuccin-tauon";
      #   rev = "main";
      #   hash = "sha256-LgndOH/6hYE/NNgxwYYfRFhkOYwdaKVIC/z+ahEgat4=";
      # };
      # See [https://nix.dev/tutorials/working-with-local-files.html#adding-files-to-the-nix-store]
      # and [https://noogle.dev/f/lib/fileset/toSource]
      themeSrc = lib.fileset.toSource {
        root = ./config/tauon;
        fileset = ./config/tauon/Cr1m.ttheme;
      };
      installPhase = ''
        ${prev.installPhase}
        cp $themeSrc/Cr1m.ttheme $out/share/tauon/theme
        '';
    }))

    #== Temp FHS environment ==#
    # For quick execution of arbitrary binaries requiring FHS conformity
    # See [https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos]
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base // {
        name = "fhs";
        targetPkgs = pkgs: (
          (base.targetPkgs pkgs) ++ (with pkgs; [
            pkg-config
            ncurses
          ])
        );
        profile = "export FHS=1";
        runScript = "bash";
        extraOutputsToInstall = ["dev"];
      })
    )

    # See: [https://ryantm.github.io/nixpkgs/builders/trivial-builders/]
  ];

  #=============== ADDITIONAL INITIALIZATION ==============#
  # Global env vars
  environment.variables = {
    EDITOR = "vim";
  };

  environment.extraInit = ''
    unset -v SSH_ASKPASS
  '';

  #=============== RICE ==============#
  stylix = {
    enable = true;
    base16Scheme = import ./config/stylix/cr1m.nix;
    image = /home/rec1dite/media/wallpapers/koiFlowers.jpg;

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 12;
    };

    # Jost, Abel, Nunito Sans

    fonts = {
      sizes.applications = 10;
      # serif = { package = pkgs.liberation_ttf; name = "Liberation Serif"; };
      # sansSerif = { package = pkgs.liberation_ttf; name = "Liberation Sans"; };
      # sansSerif = { package = pkgs.fira-code; name = "Fira Code"; };
      sansSerif = { package = pkgs.hack-font; name = "Hack"; };
      # monospace = { package = pkgs.fira-code; name = "Fira Code"; };
      # emoji = { package = pkgs.fira-code-nerdfont; name = "Fira Code"; };
    };
  };

  # See [https://nixos.wiki/wiki/KDE]
  # and [https://discourse.nixos.org/t/catppuccin-kvantum-not-working/43727/14]
  # qt = {
    # enable = true;
    # platformTheme = "gnome";
    # style = "adwaita";

    # platformTheme = "qt5ct";
    # style = "kvantum";
  # };

  # xdg.configFile = let
  #   accent = "Red";
  #   variant = "Mocha";
  #   themePkg = pkgs.catppuccin-kvantum.override { inherit accent variant; };
  # in {
  #   "Kvantum/kvantum.kvconfig".text = ''
  #     [General]
  #     theme=Catppuccin-${variant}-${accent}
  #   '';

  #   # Links theme directory from the package to a directory under `~/.config` so Kvantum can find it
  #   "Kvantum/Catppuccin-${variant}-${accent}".source = "${themePkg}/share/Kvantum/Catppuccin-${variant}-${accent}";
  # };

  #=============== MISC ==============#
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Disable AskPass (annoying GUI pop-up when Git asks for credentials)
  programs.ssh.askPassword = "";

  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    localuser = null;
  };

  programs.slock = {
    enable = true;
    package = let
      c_init = "#000000";
      c_input = "#080810";
      c_failed = "#000000";
    in (pkgs.slock.overrideAttrs (prev: {
      postPatch = ''
      sed -ir 's/\[INIT\]\s*=\s*".*",\s*/[INIT] = "${c_init}", /' config.def.h
      sed -ir 's/\[INPUT\]\s*=\s*".*",\s*/[INPUT] = "${c_input}", /' config.def.h
      sed -ir 's/\[FAILED\]\s*=\s*".*",\s*/[FAILED] = "${c_failed}", /' config.def.h
      '' + prev.postPatch;
    }));
  };

  programs.dconf = {
    enable = true;
  };

  # Enable Docker
  virtualisation.docker = {
    enable = true;
  };


  # Setup lightweight NixOS container
  # See [https://msucharski.eu/posts/application-isolation-nixos-containers]
  # and [https://wiki.archlinux.org/title/Systemd-nspawn]
  # and [https://nixos.wiki/wiki/NixOS_Containers#Usage]
  containers = {
    # To start the container:
    # sudo systemctl start container@n2x.service

    # To access the container shell:
    # sudo machinectl shell rec2dite@n2x /usr/bin/env bash --login
    # n2x = {
    #   config = import ./n2x/configuration.nix { inherit pkgs; };
    # };

    labpc = {
      config = import ./devops/configuration.nix { inherit pkgs lib stdenv; };
    };
  };
}
