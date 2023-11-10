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

  #=============== USER SOFTWARE ==============#
  # Install Nix packages only in the local user environment
  home.packages = with pkgs; [
    # To override settings for packages defined in configuration.nix:
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    #== Custom shell scripts ==#
    (pkgs.writeShellScriptBin "discord-web" ''firefox --new-window "https://discord.com/app"'')
    (pkgs.writeShellScriptBin "todoist" ''firefox --new-window "https://todoist.com/app"'')
    (pkgs.writeShellScriptBin "whatsapp" ''firefox --new-window "https://web.whatsapp.com"'')
    (pkgs.writeShellScriptBin "chatgpt" ''firefox --new-window "https://platform.openai.com/playground"'')
    (pkgs.writeShellScriptBin "gmail" ''firefox --new-window "https://mail.google.com"'')
    (pkgs.writeShellScriptBin "github" ''firefox --new-window "https://github.com/Rec1dite"'')
    (pkgs.writeShellScriptBin "clickup" ''firefox --new-window "https://clickup.up.ac.za"'')
    (pkgs.writeShellScriptBin "easywifi" ''python3 ~/.dotfiles/scripts/easywifi/easywifi.py'')
    (pkgs.writeShellScriptBin "slay" ''
      CHOSENLAYOUT=$(ls /home/rec1dite/.screenlayout | dmenu -p 'ᐒ' -fn 'Fira Code:pixelsize=14' -sb '#f43e5c' -sf '#1e1e2e' -nb '#1e1e2e' -nf '#bac2de')

      if [ "$CHOSENLAYOUT" ]; then
        /home/rec1dite/.screenlayout/$CHOSENLAYOUT
      fi
    '')
  ];

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
    # To copy a config verbatim into the Nix store and use that:
    # ".config/someProg/someProg.conf".source = ./someProg_new.conf;
    # OR to enter the config content directly:
    # ".config/someProg/someProg.conf".text = ''
    #   EXAMPLE_CONF = "Your conf here"
    # '';

    ".config/xmonad/xmonad.hs".source = ./config/xmonad/xmonad.hs;
  } // desktopFiles;

  #=============== SHELL ==============#
  # You can also manage environment variables but you will have to manually
  # $ source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
  # systemd.user.sessionVariables = {
    EDITOR = "vim";
  };

  # Configure bash
  programs.bash = {
    enable = true;

    # Set aliases
    shellAliases = {
      la = "ls -a";
    };
  };

  #=============== RICE ==============#
  programs = {
    #===== ROFI =====#
    rofi = {
      enable = true;
      # font = "monospace";
    };
  };

}