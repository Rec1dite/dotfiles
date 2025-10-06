# See docs [https://nixos.org/manual/nixos/stable/options]
# See [configuration.nix(5)]
# See [$ nixos-help]

{ inputs, config, lib, stdenv, pkgs, upkgs, home-manager, mkPoetryApplication, ... }@inps:

{
  imports =
    [
      ./hardware-configuration.nix
      ./xmonad.nix
      ./an.nix
    ];

  #=============== BOOT ==============#
  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10; # Limit the number of generations in /boot/loader/entries
  };
  # boot.loader.timeout = 1; # As per [https://discourse.nixos.org/t/how-to-add-bootentry-booting-straight-into-latest-generation/33507/2] boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];


#=============== NIX ==============#
  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "rec1dite" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # LEAVE AS-IS, NEVER CHANGE

  # Ensure <nixpkgs> aligns with the system's nixpkgs version
  # (Recommended for flakes & nixd)
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Automatic garbage collection + optimisation
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d";
  # };
  nix.settings.auto-optimise-store = true;

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  system.autoUpgrade = {
    enable = true;
    # flake = inps.self.outPath;
    # flags = [
    #   "--update-input"
    #   "nixpkgs"
    #   "-L"
    # ];
    # dates = "02:00";
    # randomizedDelaySec = "45min";
  };

  #=============== SYSTEM ==============#
  # See [https://youtu.be/pmuubmFcKtg]

  # Enable upower
  services.upower.enable = true;
  systemd.services.upower.enable = true;

  # Better scheduling for CPU cycles
  services.system76-scheduler.settings.cfsProfiles.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
      # USB_BLACKLIST_PHONE = 1;
    };
  };

  powerManagement.powertop.enable = true;

  #=============== NETWORKING ==============#
  # See [https://nixos.wiki/wiki/Networking]
  networking = {
    hostName = "n1x"; # Define your hostname.
    # wireless = {
    #   enable = true;  # Enables wireless support via wpa_supplicant.
    #   userControlled.enable = true;
    # };

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    hosts = {
      # "127.0.0.1" = [
      #   "www.reddit.com"
      #   "www.instagram.com"
      # ];
    };

    # Configure firewall
    # See [https://nixos.wiki/wiki/Firewall]
    # nftables.enable = true;
    firewall = {
      enable = true;
      # allowedTCPPorts = [];
      # allowedUDPPortRanges = [];
    };
  };


  time.timeZone = "Africa/Johannesburg";
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
  # See [https://discourse.nixos.org/t/xorg-libinput-configuration-seems-to-be-ignored/15504]
  services.libinput = {
    enable = true;

    mouse = {};
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      tapping = false;
    };
  };


  #=============== AUDIO + BLUETOOTH ==============#
  services.pulseaudio = {
    enable = false;
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
    nerd-fonts.fira-code
    nerd-fonts.hack

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    roboto
    texlivePackages.nunito
  ];


  #=============== GPU ==============#
  # See [https://nixos.wiki/wiki/Nvidia#Modifying_NixOS_Configuration]
  # Enable OpenGL

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
      # NOTE: Conflicting with nixos-hardware
      #       Potentially use lib.mkForce if necessary
      amdgpuBusId = lib.mkForce "PCI:6:0:0";
      nvidiaBusId = lib.mkForce "PCI:1:0:0";

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
    extraGroups = [ "networkmanager" "wheel" "audio" "mlocate" "docker" "ydotool" ];
    packages = with pkgs; [];
  };


  #=============== SYSTEM SOFTARE ==============#
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      font  = "Fira Code";
      fontSize = "9";
      # background = "${./wallpaper.png}";
      loginBackground = false;
    })

    (blender.override { cudaSupport = true; })
    (btop.override { cudaSupport = true; })

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
      postInstall = ''
        ${prev.postInstall}
        cp $themeSrc/Cr1m.ttheme $out/lib/python*/site-packages/tauon/theme
        '';
    }))

    (pkgs.callPackage ./derivations/hints {})

    #== Temp FHS environment ==#
    # For quick execution of arbitrary binaries requiring FHS conformity
    # See [https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos]
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSEnv (base // {
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
  ]);

  #=============== ADDITIONAL INITIALIZATION ==============#
  # Global env vars
  environment.variables = {
    EDITOR = "vim";

    # Enable accessibility for `hints`
    # See [https://github.com/AlfredoSequeida/hints?tab=readme-ov-file#system-requirements]
    ACCESSIBILITY_ENABLED = "1";
    GTK_MODULES = "gail:atk-bridge";
    OOO_FORCE_DESKTOP = "gnome";
    GNOME_ACCESSIBILITY = "1";
    QT_ACCESSIBILITY = "1";
    QT_ACCESSIBILITY_ALWAYS_ON = "1";

    # TODO: Hints packaging
    # See: [https://github.com/AlfredoSequeida/hints/issues/30]
    # and: [https://github.com/NixOS/nixpkgs/issues/376993]
  };

  environment.extraInit = ''
    unset -v SSH_ASKPASS
  '';

  #=============== RICE ==============#
  stylix = {
    enable = true;
    # See [https://github.com/SenchoPens/base16.nix/tree/main#%EF%B8%8F-troubleshooting]
    base16Scheme = import ./config/stylix/cr1m.nix;
    # base16Scheme = ./config/stylix/cr1m.yaml;
    image = ./config/stylix/koiFlowers.jpg;

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 12;
    };

    # Jost, Abel, Nunito Sans

    fonts = {
      sizes.applications = 10;
      # sansSerif = { package = pkgs.hack-font; name = "Hack"; };

      # serif = { package = pkgs.liberation_ttf; name = "Liberation Serif"; };
      # sansSerif = { package = pkgs.liberation_ttf; name = "Liberation Sans"; };
      # sansSerif = { package = pkgs.fira-code; name = "Fira Code"; };
      # monospace = { package = pkgs.fira-code; name = "Fira Code"; };
      # emoji = { package = pkgs.fira-code-nerdfont; name = "Fira Code"; };
    };
  };

  # See [https://nixos.wiki/wiki/KDE]
  # and [https://discourse.nixos.org/t/catppuccin-kvantum-not-working/43727/14]
  qt = {
    enable = true;
    platformTheme = lib.mkForce "gnome";
    style = "adwaita";

    # platformTheme = "qt5ct";
    # style = "kvantum";
  };

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

  programs.nix-ld.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.mlocate;
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

  # services.gvfs = { enable = true; };

  programs.dconf = { enable = true; };

  # services.dnsmasq = { enable = true; };

  virtualisation.docker = { enable = true; };

  services.teamviewer = { enable = true; };

  # `hints` dependencies
  services.gnome.at-spi2-core = { enable = true; };
  programs.ydotool.enable = true;

  services.postgresql.enable = true;
  services.pgadmin = {
    initialEmail = "rec1dite@gmail.com";
    initialPasswordFile = ./config/postgres/.pgadmin_pass;
    enable = true;
  };

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-7_0; # See [https://wiki.nixos.org/wiki/MongoDB]
    enableAuth = false;
  };

  # services.neo4j.enable = true;

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

    # labpc = {
    #   config = import ./devops/configuration.nix { inherit pkgs lib stdenv; };
    # };
  };
}
