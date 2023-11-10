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


  #=============== NIX ==============#
  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Leave as-is
  system.stateVersion = "23.05";

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
    # Configure keymap in X11
    layout = "za";
    xkbVariant = "";

    # Configure input devices
    libinput = {
      enable = true;
      mouse = {};
      touchpad = {
        naturalScrolling = true;
      };
    };

    # Set keyrepeat values (eqiv. to `xset r rate 250 50`)
    autoRepeatDelay = 250;
    autoRepeatInterval = 50;
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
    #== Editors ==#
    vim

    #== System utils ==#
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
    discord
    firefox
    imagemagick7
    neofetch
    vscode
    youtube-music
    cava
    # fish
  ];


  #=============== MISC ==============#
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
  };

  programs.slock = {
    enable = true;
  };
}
