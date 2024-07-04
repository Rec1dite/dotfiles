# See docs [https://nix-community.github.io/home-manager/options.html]
# See [https://youtu.be/IiyBeR-Guqw]
{ config, lib, pkgs, ... }:

let
  desktopEntries = [ 
    "discord"
    "todoist"
    "whatsapp"
    "chatgpt"
    "gmail"
    "github"
    "clickup"
  ];
  # vscodeKeybindings = import ./config/vscode/keybindings.nix; # Removed in favor of Settings Sync
  upkg = import <unstable> { overlays = [
    # See: [https://nixos.org/manual/nixpkgs/stable/#chap-overlays]
    # (self: super: { hie-nix = import ~/src/hie-nix {}; })
  ]; };
in
{
  #=============== HOME MANAGER ==============#
  # Specify user information
  home.username = "rec1dite";
  home.homeDirectory = "/home/rec1dite";

  # Leave as-is
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  # See [https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree]
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true; # Allow all unfree packages
  # nixpkgs.config.allowUnfreePredicate = pkg: (builtins.elem (lib.getName pkg) [ # Allow only specified unfree packages
  #   "vscode"
  # ]);

  #=============== USER SOFTWARE ==============#
  # Install Nix packages only in the local user environment
  home.packages = with pkgs; [
    dconf # See [https://github.com/nix-community/home-manager/issues/3113#issuecomment-1194271028]

    # To override settings for packages defined in configuration.nix:
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    #== Custom shell scripts ==#
    (pkgs.writeShellScriptBin "discord" ''firefox --new-window "https://discord.com/app"'')
    (pkgs.writeShellScriptBin "todoist" ''firefox --new-window "https://todoist.com/app"'')
    (pkgs.writeShellScriptBin "whatsapp" ''firefox --new-window "https://web.whatsapp.com"'')
    (pkgs.writeShellScriptBin "chatgpt" ''firefox --new-window "https://platform.openai.com/playground/assistants"'')
    (pkgs.writeShellScriptBin "gmail" ''firefox --new-window "https://mail.google.com"'')
    (pkgs.writeShellScriptBin "github" ''firefox --new-window "https://github.com/Rec1dite"'')
    (pkgs.writeShellScriptBin "clickup" ''firefox --new-window "https://clickup.up.ac.za"'')
    (pkgs.writeShellScriptBin "easywifi" ''python3 ~/.dotfiles/scripts/easywifi/easywifi.py'')
    (pkgs.writeShellScriptBin "slay" ''
      CHOSENLAYOUT=$(ls /home/rec1dite/.screenlayout | dmenu -p 'ᐒ' -fn 'Fira Code:pixelsize=14' -sb '#f43e5c' -sf '#1e1e2e' -nb '#1e1e2e' -nf '#bac2de')

      if [ "$CHOSENLAYOUT" ]; then
        /home/rec1dite/.screenlayout/$CHOSENLAYOUT
      fi
    '') ];

  programs = {
    #===== GIT =====#
    git = {
      enable = true;
      userName = "Rec1dite";
      userEmail = "rec1dite@gmail.com";

      aliases = {
        graph = "";
      };
      # lfs.enable = true;

      # Configure git delta [https://github.com/dandavison/delta]
      delta = {
        enable = true;
        options = {
          # decorations = {
          #   commit-decoration-style = "bold yellow box ul";
          #   file-decoration-style = "none";
          #   file-style = "bold yellow ul";
          # };
          # features = "decorations";
          # whitespace-error-style = "22 reverse";
        };
      };
    };

    #===== ROFI =====#
    rofi = {
      enable = true;
      # font = "monospace";
      theme = "main";
      # extraConfig = ./config/rofi/config.rasi;
    };

    #===== VSCODE =====#
    vscode = {
      enable = true;
      extensions = [];
      # haskell = {
      #   enable = true;
      #   hie = {
      #     enable = true;
      #     # executablePath = "";
      #   };
      # };
      # keybindings = vscodeKeybindings; # Removed in favor of Settings Sync
    };

    #===== BAT =====#
    bat = {
      enable = true;
      config = {
        theme = "base16"; # $ bat --list-themes
      };
    };
    # TODO: trayer, bat-extras
  };

  services = {
    polybar = {
      enable = true;
      # package = pkgs.polybar.override {
      #   alsaSupport = true;
      #   githubSupport = true;
      #   mpdSupport = true;
      #   pulseSupport = true;
      # };
      config = ./config/polybar/config.ini;
      extraConfig = ''
[module/xmonad]
type = custom/script
exec = ${pkgs.xmonad-log}/bin/xmonad-log
tail = true
      '';

      # script = ''echo "----- $(date +%c) -----" ; polybar main & 2>&1 | tee -a /tmp/polybar.log & disown'';
      script = "polybar main &";
    };
  };

  #=============== DOTFILES ==============#
  home.file = let
    # Generate .desktop entries
    desktopFiles = builtins.listToAttrs (map (
      name: {
        name = ".local/share/applications/${name}.desktop";
        value = { source = ./applications + "/${name}.desktop"; };
      }
    ) desktopEntries);
  in
  {
    #----- Deploy config files -----#

    # To enter the config content directly:
    # ".config/someProg/someProg.conf".text = ''
    #   EXAMPLE_CONF = "Your conf here"
    # '';

    # Also see: `lib.file.mkOutOfStoreSymlink`

    # XMonad
    # ".config/xmonad/xmonad.hs".source = ./config/xmonad/xmonad.hs; # Moved to xmonad.nix's `config` setting

    # Kitty
    ".config/kitty/kitty.conf".source = ./config/kitty/kitty.conf;

    # Neofetch
    ".config/neofetch/config.conf".source = ./config/neofetch/config.conf;

    # Rofi
    # ".config/rofi/config.rasi".source = ./config/rofi/config.rasi;
    ".local/share/rofi/themes/main.rasi".source = ./config/rofi/mocha.rasi;

    # VLC
    # REMOVED: Broken resizing with tiling WM
    # ".local/share/vlc/skins2/Arc-Dark.vlt".source = ./config/vlc/Arc-Dark.vlt;

    # Polybar scripts
    polybarScripts = {
      source = ./config/polybar/scripts;
      target = ".config/polybar/scripts";
      recursive = true;
    };

    # Disable middle click paste
    # See [https://unix.stackexchange.com/a/277488]
    ".xbindkeysrc".text = ''
      "echo -n | xsel -n -i; pkill xbindkeys; xdotool click 2; xbindkeys"
      b:2 + Release
    '';

  } // desktopFiles;

  #=============== XSESSION PROGRAMS ==============#
  xsession = {
    enable = true;

    # windowManager.start = ''
      # systemctl --user restart polybar
    # '';

    windowManager.xmonad = {
      enable = true;
      # enableConfiguredRecompile = true;
      enableContribAndExtras = true;

      extraPackages = haskpkgs: [
        haskpkgs.dbus
        haskpkgs.monad-logger
        haskpkgs.xmonad-contrib
      ];

      config = ./config/xmonad/xmonad.hs;
    };
  };


  #=============== SHELL ==============#
  # You can also manage environment variables but you will have to manually
  # $ source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
  # systemd.user.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {

    # Configure bash
    bash = {
      enable = true;

      # Set aliases
      shellAliases = {
        la = "ls -a";
        conf = "code /home/rec1dite/.dotfiles";
      };

      # Bashrc configs
      bashrcExtra = "
        xset r rate 250 50;
      ";
    };

    # Configure vim
    vim = {
      enable = true;
      extraConfig =
      ''
        set ignorecase
        set smartcase

        set nu
        set rnu
      '';
    };

  };

  #=============== RICE ==============#
  # See [https://youtu.be/m_6eqpKrtxk]
  gtk = {
    enable = true;
    font.name = "Fira Code";

    #===== CURSOR =====#
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 10;
    };

    #===== TRAFFIC LIGHTS =====#
    # Disable traffic lights
    # See [https://docs.gtk.org/gtk4/property.Settings.gtk-decoration-layout.html]
    gtk3.extraConfig.gtk-decoration-layout = "menu:none";
    gtk4.extraConfig.gtk-decoration-layout = "menu:none";

    #===== GTK THEME =====#
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "compact";
        tweaks = [ "rimless" "black" "normal" ];
        variant = "mocha";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark"; # TODO
      # package = pkgs.adwaita-qt;
    };
  };

  services = {
    # After changing: `systemctl --user restart picom.service`
    #===== PICOM =====#
    picom = {
      enable = true;
      shadow = true;
      shadowExclude = [
        # See picom(1) for more 'CONDITION' rules
        "class_g = 'dmenu'"
        "class_g = 'Polybar'"
      ];
      # shadowOffsets = [-15 -15]; # default
      # shadowOpacity = 0.75; # default
      # fade = true;
      # fadeDelta = 2;
      # activeOpacity = 0.98;
      # inactiveOpacity = 0.95;
    };
  };
}