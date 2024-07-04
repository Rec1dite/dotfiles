# See docs [https://nixos.org/manual/nixos/stable/options]
# See [configuration.nix(5)]
# See [$ nixos-help]

{ config, lib, pkgs, ... }:

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
  boot.loader.timeout = 1; # As per [https://discourse.nixos.org/t/how-to-add-bootentry-booting-straight-into-latest-generation/33507/2]
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];


  #=============== NIX ==============#
  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Leave as-is
  system.stateVersion = "23.05";


  #=============== SYSTEM ==============#
  # Enable upower
  services.upower.enable = true;
  systemd.services.upower.enable = true;

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
    layout = "za";
    xkbVariant = "";

    # Configure input devices
    libinput = {
      enable = true;

      mouse = {};
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    # Set keyrepeat values (eqiv. to `xset r rate 225 60`)
    autoRepeatDelay = 225;
    autoRepeatInterval = 60;

    exportConfiguration = true; # Creates a symlink at /etc/X11/xorg.conf pointing to the main config
  };


  #=============== DISPLAY MANAGER ==============#
  services.xserver = {
    displayManager = {};
  };

  #=============== AUDIO + BLUETOOTH ==============#
  # Enable audio via PulseAudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true; # Enable compatibility with 32-bit apps
  nixpkgs.config.pulseaudio = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # FOR HOME MANAGER:
  # # Enable headset audio controls (play/pause etc.)
  # systemd.user.services.mpris-proxy = {
  #   description = "Mpris proxy";
  #   after = [ "network.target" "sound.target" ];
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.ExecStart = "${pkgs.bluez}";
  # };


  #=============== FONTS ==============#
  # Install fonts
  fonts.fonts = with pkgs; [
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
    enableUserService = true;
    # auraConfig
  };


  #=============== USER ACCOUNTS ==============#
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rec1dite = {
    isNormalUser = true;
    description = "Rec1dite";
    extraGroups = [ "networkmanager" "wheel" "audio" "mlocate" ];
    packages = with pkgs; [];
  };


  #=============== SYSTEM SOFTARE ==============#
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #== System utils ==#
    coreutils
    bottom
    file
    git
    gparted
    htop
    kitty
    lshw
    mpv
    neofetch
    pciutils
    sxiv
    wget
    tree
    ripgrep
    nix-index # Enables `nix-locate`
    xmonad-log

    #== Programming ==#
    vim
    haskell-language-server
    ghc

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

    #== Navigation ==#
    dmenu
    gnome.nautilus
    ranger
    rofi

    #== Desktop applications ==#
    blender
    cava
    firefox
    imagemagick7
    neofetch
    obs-studio
    okular
    xournalpp
    youtube-music
    vlc
    # fish

    # See: [https://nixos.org/manual/nixpkgs/stable/#chap-overrides]
    tauon
    # tauon.override (prev: {})
  ];

  #=============== ADDITIONAL INITIALIZATION ==============#
  environment.extraInit = ''
    unset -v SSH_ASKPASS
  '';

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
    locate = pkgs.mlocate;
    localuser = null;
  };

  programs.slock = {
    enable = true;
  };
}
