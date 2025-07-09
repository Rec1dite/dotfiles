# See docs [https://nix-community.github.io/home-manager/options.html]
# See [https://youtu.be/IiyBeR-Guqw]
{ config, lib, pkgs, ... }:

let
  rofi-emoji = (pkgs.rofi-emoji.overrideAttrs (prev: {
    postPatch = prev.postPatch + ''
cat << EOF >> all_emojis.txt
ᐒ	Custom	custom	rec1dite	rec1dite
ඞ	Custom	custom	amongus	amogus

EOF
      '';
  }));

  # vscodeKeybindings = import ./config/vscode/keybindings.nix; # Removed in favor of Settings Sync
  upkg = import <unstable> { overlays = [
    # See: [https://nixos.org/manual/nixpkgs/stable/#chap-overlays]
    # (self: super: { hie-nix = import ~/src/hie-nix {}; })
  ]; };
in
{
  imports = [ ./desktopEntries.nix ];

  #=============== HOME MANAGER ==============#
  # Specify user information
  home.username = "rec1dite";
  home.homeDirectory = "/home/rec1dite";

  # Leave as-is
  home.stateVersion = "24.05";

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
    (pkgs.writeShellScriptBin "easywifi" ''python3 ~/.dotfiles/scripts/easywifi/easywifi.py'')
    (pkgs.writeShellScriptBin "slay" ''
      CHOSENLAYOUT=$(ls /home/rec1dite/.screenlayout | dmenu -p 'ᐒ' -fn 'Fira Code:pixelsize=14' -sb '#f43e5c' -sf '#1e1e2e' -nb '#1e1e2e' -nf '#bac2de')

      if [ "$CHOSENLAYOUT" ]; then
        /home/rec1dite/.screenlayout/$CHOSENLAYOUT
      fi
    '') ];

  programs = {
    #===== SSH =====#
    ssh = {
      enable = true;

      matchBlocks = {
        #----- GitHub -----#
        "github-rec1dite" = {
          hostname = "github.com";
          user = "git";
          identityFile = "/home/rec1dite/.ssh/id_ed25519_rec1dite";
        };
        "github-digir" = {
          hostname = "github.com";
          user = "git";
          identityFile = "/home/rec1dite/.ssh/id_ed25519_digir";
        };

        #----- Misc -----#
        "bdclient.cs.up.ac.za" = {
          hostname = "bdclient.cs.up.ac.za";
          user = "techteam";
        };
      };
    };

    #===== GIT =====#
    git = {
      enable = true;

      includes = [
        {
          condition = "gitdir:~/repos/";
          contents = {
            user.name  = "Rec1dite";
            user.email = "rec1dite@gmail.com";

            # Auto substitute to the correct SSH host
            url."git@github-rec1dite:".insteadOf = ["git@github.com:" "https://github.com/"];
          };
        }

        {
          condition = "gitdir:~/grad/";
          contents = {
            user.name  = "digir";
            user.email = "dino.gironi@bbd.co.za";

            url."git@github-digir:".insteadOf = ["git@github.com:" "https://github.com/"];
          };
        }
      ];

      extraConfig = {
        core = {
          editor = "code --wait";
          autocrlf = true;
        };
        diff.tool = "vscode";
        merge.tool = "vscode";
        "difftool \"vscode\"".cmd = "code --wait --diff $LOCAL $REMOTE";
        "mergetool \"vscode\"".cmd = "code --wait $MERGED";
      };

      aliases = {
        graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
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

    #===== DIRENV =====#
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    #===== STARSHIP =====#
    starship = {
      enable = true;
      enableBashIntegration = true;
      # See: [https://starship.rs/config]
      settings = {
        # Move directory to second line
        format = "$all$directory$character";
      };
    };
    #===== TMUX =====#
    tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      historyLimit = 10000;
    };

    #===== ROFI =====#
    rofi = {
      enable = true;
      # font = "monospace";
      theme = "main";
      terminal = "${pkgs.kitty}/bin/kitty";
      location = "center";

      plugins = [ rofi-emoji ];

      # See: [$ rofi -help]
      # and: [$ rofi -dump-config | less]
      extraConfig = {
        modi = "run,emoji,drun,clipboard:greenclip print,window";
        # icon-theme = "Oranchelo";
        # window-thumbnail = true;
        icon-theme = "Papirus";
        show-icons = true;
        terminal = "kitty";
        drun-display-format = "{icon} {name}";
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps";
        display-run = "   Run";
        display-emoji = " 󰞅 Emoji";
        display-window = " 󰕰 Window";
        display-clipboard = " 󱉣  Clipboard";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;

        # Vim keybinds
        # See [https://man.archlinux.org/man/community/rofi/rofi-keys.5.en]
        kb-row-up = "Super_L+k,Up";
        kb-row-down = "Super_L+j,Down";
        kb-row-left = "Super_L+h";
        kb-row-right = "Super_L+l";

        kb-accept-entry = "Return,KP_Enter";

        kb-mode-next = "Super_L+K,Shift+Right";
        kb-mode-previous = "Super_L+J,Shift+Left";
      };
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
    # TODO: trayer, bat-extras, zellij

    #===== YAZI =====#
    # See [https://yazi-rs.github.io/docs/installation/#nix]
    yazi = let
      plugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        hash = "sha256-mQkivPt9tOXom78jgvSwveF/8SD8M2XCXxGY8oijl+o=";
      };
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "main";
        hash = "sha256-wESy7lFWan/jTYgtKGQ3lfK69SnDZ+kDx4K1NfY4xf4=";
      };
      rich-preview = pkgs.fetchFromGitHub {
        owner = "AnirudhG07";
        repo = "rich-preview.yazi";
        rev = "main";
        hash = "sha256-TwL0gIcDhp0hMnC4dPqaVWIXhghy977DmZ+yPoF/N98=";
      };
      bookmarks = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "bookmarks.yazi";
        rev = "main";
        hash = "sha256-GLi6X06irj3sS8FoOMPz2mFSlf60dO7GDYq10omQiOs=";
      };
    in {
      enable = true;
      # shellWrapperName = "y";
      theme = {};
      settings = {
        plugin = {
          prepend_fetchers = [
            { id = "git"; name = "*";  run = "git"; }
            { id = "git"; name = "*/"; run = "git"; }
          ];
          prepend_previewers = [
            { name = "*.csv";   run = "rich-preview"; }
            { name = "*.ipynb"; run = "rich-preview"; }
            { name = "*.json";  run = "rich-preview"; }
            { name = "*.md";    run = "rich-preview"; }
            { name = "*.rst";   run = "rich-preview"; }
          ];
        };
        preview = {
        };
      };
      keymap = {
        manager.prepend_keymap = [
          {
            on = [ "c" "m" ];
            run = "plugin chmod";
            desc = "chmod selected files";
          }
          {
            on = "T";
            run = "plugin --sync max-preview";
            desc = "Toggle maximized preview";
          }
          {
            on = "<c-L>";
            run = "plugin --sync hide-preview";
            desc = "Toggle preview visibility";
          }
          {
            on = "m";
            run = "plugin bookmarks --args=save";
            desc = "Save current position as a bookmark";
          }
          {
            on = "'";
            run = "plugin bookmarks --args=jump";
            desc = "Jump to a bookmark";
          }
          {
            on = [ "b" "d" ];
            run = "plugin bookmarks --args=delete";
            desc = "Delete a bookmark";
          }
          {
            on = [ "b" "D" ];
            run = "plugin bookmarks --args=delete_all";
            desc = "Delete all bookmarks";
          }
        ];

      };
      plugins = {
        inherit starship rich-preview bookmarks;
        chmod = "${plugins}/chmod.yazi";
        git = "${plugins}/git.yazi";
        hide-preview = "${plugins}/hide-preview.yazi";
        max-preview = "${plugins}/max-preview.yazi";
      };
    };
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

    flameshot = {
      enable = true;
      settings = {
        General = {
          # uiColor = "#f43e5c";
          # contrastUiColor = "#1e1e2e";
          contrastUiColor = "#f43e5c";
          uiColor = "#181825";
          savePath = "/home/rec1dite/media/screenshots";
          savePathFixed = true;
        };
      };
    };

    dunst = {
      enable = true;
    };
  };

  #=============== DOTFILES ==============#
  home.file = let
    # Generate .desktop entries
    # desktopFiles = builtins.listToAttrs (map (
    #   name: {
    #     name = ".local/share/applications/${name}.desktop";
    #     value = { source = ./applications + "/${name}.desktop"; };
    #   }
    # ) desktopEntries);

    blenderVersion = lib.versions.majorMinor pkgs.blender.version;
  in
  {
    #----- Deploy config files -----#

    # To enter the config content directly:
    # ".config/someProg/someProg.conf".text = ''
    #   EXAMPLE_CONF = "Your conf here"
    # '';

    # Also see: `lib.file.mkOutOfStoreSymlink`

    # Kitty
    ".config/kitty/kitty.conf".source = ./config/kitty/kitty.conf;

    # Neofetch
    ".config/neofetch/config.conf".source = ./config/neofetch/config.conf;

    # Rofi
    # ".config/rofi/config.rasi".source = ./config/rofi/config.rasi;
    ".local/share/rofi/themes/main.rasi".source = ./config/rofi/mocha.rasi;
    ".config/greenclip.toml".source = ./config/rofi/greenclip.toml;

    # Okular
    ".config/okularpartrc".source = ./config/okular/okularpartrc;

    # Cava
    ".config/cava/config".source = ./config/cava/config;

    # Blender
    ".config/blender/${blenderVersion}/scripts/presets/interface_theme/mocha_cr1m.xml".source = ./config/blender/mocha_cr1m.xml;

    # UV
    ".config/uv/uv.toml".source = ./config/uv/uv.toml;

    # PNPM
    ".config/pnpm/rc".source = ./config/pnpm/rc;

    # VLC
    # REMOVED: Broken resizing with tiling WM
    # ".local/share/vlc/skins2/Arc-Dark.vlt".source = ./config/vlc/Arc-Dark.vlt;

    # Polybar scripts
    # ".config/polybar/scripts/cava.sh".source = pkgs.substituteAll {
    #   src = ./config/polybar/scripts/polybar-cava/cava.sh;
    #   cava = "${pkgs.cava}";
    # };

    # espr = {
    #   source = ./config/polybar/scripts/espr;
    #   target = ".config/polybar/scripts/espr";
    #   recursive = false;
    # };

    # ".config/polybar/scripts/timer.sh".source = pkgs.substituteAll {
    #   src = ./config/polybar/scripts/polybar-timer/timer.sh;
    #   cava = "${pkgs.cava}";
    # };

    # Disable middle click paste
    # See [https://unix.stackexchange.com/a/277488]
    ".xbindkeysrc".text = ''
      "echo -n | xsel -n -i; pkill xbindkeys; xdotool click 2; xbindkeys"
      b:2 + Release
    '';

  }; # // desktopFiles;

  #=============== XSESSION PROGRAMS ==============#
  xsession = {
    enable = true;

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
    EDITOR = "vim";

    # See eza_colors(5)
    # Unify colors on permission outputs
    EZA_COLORS = "ur=96:uw=96:ux=96:ue=96:gr=96:gw=96:gx=96:tr=96:tw=96:tx=96";
  };

  programs = {

    # Configure bash
    bash = {
      enable = true;

      # Set aliases
      shellAliases = {
        ls = "eza --icons --git";
        la = "ls -a";
        ll = "ls -la";
        lsblk = "lsblk -o NAME,LABEL,FSTYPE,SIZE,FSUSED,MOUNTPOINTS,UUID";
        conf = "code /home/rec1dite/.dotfiles";
        clock = "tty-clock -scC 1";
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

        set hlsearch
      '';
    };

    neovim = {
      enable = true;
    };

  };

  #=============== RICE ==============#
  catppuccin = {
    flavor = "mocha";
    accent = "red";
  };

  stylix = {
    targets = {
      rofi.enable = false;
      bat.enable = false;
      vscode.enable = false;
      firefox.enable = false;
      # chromium.enable = false;

      # kde.enable = false; # Until [https://github.com/danth/stylix/issues/489] is fixed
    };
  };

  xdg = {
    enable = true;
  };

  # See [https://youtu.be/m_6eqpKrtxk]
  gtk = {
    enable = true;
    # font.name = "Fira Code";

    #===== CURSOR =====#
    # cursorTheme = {
    #   name = "Bibata-Modern-Ice";
    #   package = pkgs.bibata-cursors;
    #   size = 6;
    # };

    #===== ICONS =====#
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    #===== TRAFFIC LIGHTS =====#
    # Disable traffic lights
    # See [https://docs.gtk.org/gtk4/property.Settings.gtk-decoration-layout.html]
    gtk3.extraConfig.gtk-decoration-layout = "menu:none";
    gtk4.extraConfig.gtk-decoration-layout = "menu:none";

    #===== GTK THEME =====#
    # theme = {
    #   name = "Catppuccin-Mocha-Compact-Blue-Dark";
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = [ "blue" ];
    #     size = "compact";
    #     tweaks = [ "rimless" "black" "normal" ];
    #     variant = "mocha";
    #   };
    # };
  };

  # If Stylix issues with QT persist,
  # see [https://nix.catppuccin.com/options/home-manager-options.html#qtstylecatppuccinenable]
  qt = {
    enable = true;
    # platformTheme.name = "kvantum";
    # style = {
      # catppuccin = {
      #   enable = true;
      #   apply = true;
      # };
      # name = "kvantum";
      # package = pkgs.adwaita-qt;
    # };
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
        "class_g = 'Firefox' && argb"
        "window_type = 'menu'"
        "window_type = 'dropdown_menu'"
        "window_type = 'popup_menu'"
        "window_type = 'tooltip'"
        "window_type = 'utility'" # See [https://github.com/chjj/compton/issues/333#issuecomment-169538630]
      ];
      # shadowOffsets = [-15 -15]; # default
      # shadowOpacity = 0.75; # default
      # fade = true;
      # fadeDelta = 2;
      # activeOpacity = 0.98;
      # inactiveOpacity = 0.95;
    };

    #===== FUSUMA =====#
    # Enable touchpad gestures
    # Also see: [https://github.com/iberianpig/fusuma-plugin-tap]
    fusuma = {
      enable = true;
      settings = import ./config/fusuma/fusuma.nix;
    };
  };


  #=============== SYSTEMD SERVICES ==============#

  # See: [https://aur.archlinux.org/cgit/aur.git/tree/greenclip.service?h=rofi-greenclip]
  systemd.user.services.greenclip = {
    Unit = {
      Description = "Greenclip agent";
      After = "display-manager.service";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
      Restart = "always";
      # RestartSec = "3s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
