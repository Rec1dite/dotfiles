# See [https://youtu.be/IiyBeR-Guqw]

{ config, pkgs, ... }:

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
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    #== Custom shell scripts ==#
    (pkgs.writeShellScriptBin "slay" ''
      echo "Hello, ${config.home.username}!"
    '') # TODO: slay
  ];


  #=============== DOTFILES ==============#
  home.file = {
    # To copy a config verbatim into the Nix store and use that:
    # ".config/someProg/someProg.conf".source = ./someProg_new.conf;
    # OR to enter the config content directly:
    # ".config/someProg/someProg.conf".text = ''
    #   EXAMPLE_CONF = "Your conf here"
    # '';

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


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