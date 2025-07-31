{ pkgs, ... }: {
  xdg.desktopEntries = {
    chatgpt = {
      type =        "Application";
      name =        "ChatGPT";
      genericName = "ChatGPT";
      comment =     "ChatGPT";
      exec =        "chatgpt";
      icon =        "appimagekit-wewechat";
      terminal =    false;
      categories =  [ "Application" "Network" ];
    };

    discord = {
      type =        "Application";
      name =        "Discord";
      genericName = "Messenger";
      comment =     "Discord";
      exec =        "discord";
      icon =        "discord";
      terminal =    false;
      categories =  [ "AudioVideo" "Network" ];
    };

    gmail = {
      type =        "Application";
      name =        "GMail";
      genericName = "Email";
      comment =     "GMail";
      exec =        "gmail";
      icon =        "gmail";
      terminal =    false;
      categories =  [ "AudioVideo" "Network" ];
    };

    github = {
      type =        "Application";
      name =        "GitHub";
      genericName = "GitHub";
      comment =     "GitHub";
      exec =        "github";
      icon =        "github";
      terminal =    false;
      categories =  [ "Network" ];
    };

    todoist = {
      type =        "Application";
      name =        "Todoist";
      genericName = "Calendar";
      comment =     "Todoist";
      exec =        "todoist";
      icon =        "todoist";
      terminal =    false;
      categories =  [ "AudioVideo" "Network" ];
    };

    whatsapp = {
      type =        "Application";
      name =        "Whatsapp";
      genericName = "Messenger";
      comment =     "Whatsapp";
      exec =        "whatsapp";
      icon =        "whatsapp";
      terminal =    false;
      categories =  [ "AudioVideo" "Network" ];
    };

    ytmusic = {
      type =        "Application";
      name =        "Youtube Music (Firefox)";
      genericName = "Music";
      comment =     "Youtube Music";
      exec =        "ytmusic";
      icon =        "youtube-music";
      terminal =    false;
      categories =  [ "Music" ];
    };

    teams = {
      type =        "Application";
      name =        "Microsoft Teams";
      genericName = "Teams";
      comment =     "Microsoft Teams";
      exec =        "msteams";
      icon =        "teams";
      terminal =    false;
      categories =  [ "AudioVideo" "Network" ];
    };
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "discord"       ''firefox --new-window "https://discord.com/app"''    )
    (pkgs.writeShellScriptBin "todoist"       ''firefox --new-window "https://todoist.com/app"''    )
    (pkgs.writeShellScriptBin "whatsapp"      ''firefox --new-window "https://web.whatsapp.com"''   )
    (pkgs.writeShellScriptBin "chatgpt"       ''firefox --new-window "https://chatgpt.com"''        )
    (pkgs.writeShellScriptBin "gmail"         ''firefox --new-window "https://mail.google.com"''    )
    (pkgs.writeShellScriptBin "github"        ''firefox --new-window "https://github.com/rec1dite"'')
    (pkgs.writeShellScriptBin "ytmusic"       ''firefox --new-window "https://music.youtube.com"''  )
    (pkgs.writeShellScriptBin "msteams"       ''firefox --new-window "https://teams.microsoft.com"'')
    (pkgs.writeShellScriptBin "polybar-timer" ''
      #!/bin/sh
      ~/.dotfiles/config/polybar/scripts/polybar-timer/timer.sh "$@"
    '')
  ];
}