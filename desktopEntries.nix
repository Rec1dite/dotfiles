{ pkgs, ... }: {
  xdg.desktopEntries = {
    chatgpt = {
      type = "Application";
      name = "ChatGPT";
      genericName = "ChatGPT";
      comment = "ChatGPT";
      exec = "chatgpt";
      icon = "appimagekit-wewechat";
      terminal = false;
      categories = [ "Application" "Network" ];
      # keywords = [ "Messages" ];
    };

    clickup = {
      type = "Application";
      name = "ClickUp";
      genericName = "University";
      comment = "ClickUp";
      exec = "clickup";
      icon = "bookmark";
      terminal = false;
      categories = [ "AudioVideo" "Network" ];
      # keywords = [ "University" "Work" "Projects" "Lectures" ];
    };

    discord = {
      type = "Application";
      name = "Discord";
      genericName = "Messenger";
      comment = "Discord";
      exec = "discord";
      icon = "discord";
      terminal = false;
      categories = [ "AudioVideo" "Network" ];
      # keywords = [ "Social" "Messages" ];
    };

    gmail = {
      type = "Application";
      name = "GMail";
      genericName = "Email";
      comment = "GMail";
      exec = "gmail";
      icon = "gmail";
      terminal = false;
      categories = [ "AudioVideo" "Network" ];
      # keywords = [ "Social" "Email" "Messages" ];
    };

    github = {
      type = "Application";
      name = "GitHub";
      genericName = "GitHub";
      comment = "GitHub";
      exec = "github";
      icon = "github";
      terminal = false;
      categories = [ "Network" ];
      # keywords = [ "Git" "Code" "Programming" "Repository" ];
    };

    todoist = {
      type = "Application";
      name = "Todoist";
      genericName = "Calendar";
      comment = "Todoist";
      exec = "todoist";
      icon = "todoist";
      terminal = false;
      categories = [ "AudioVideo" "Network" ];
      # keywords = [ "Messages" "Calendar" "Todo" "Tasks" ];
    };

    whatsapp = {
      type = "Application";
      name = "Whatsapp";
      genericName = "Messenger";
      comment = "Whatsapp";
      exec = "whatsapp";
      icon = "whatsapp";
      terminal = false;
      categories = [ "AudioVideo" "Network" ];
      # keywords = [ "Social" "Messages" ];
    };

    ytmusic = {
      type = "Application";
      name = "Youtube Music (Firefox)";
      genericName = "Music";
      comment = "Youtube Music";
      exec = "ytmusic";
      icon = "youtube-music";
      terminal = false;
      categories = [ "Music" ];
      # keywords = [ "Music" "Media" "Song" ];
    };
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "discord" ''firefox --new-window "https://discord.com/app"'')
    (pkgs.writeShellScriptBin "todoist" ''firefox --new-window "https://todoist.com/app"'')
    (pkgs.writeShellScriptBin "whatsapp" ''firefox --new-window "https://web.whatsapp.com"'')
    (pkgs.writeShellScriptBin "chatgpt" ''firefox --new-window "https://platform.openai.com/playground/assistants"'')
    (pkgs.writeShellScriptBin "gmail" ''firefox --new-window "https://mail.google.com"'')
    (pkgs.writeShellScriptBin "github" ''firefox --new-window "https://github.com/Rec1dite"'')
    (pkgs.writeShellScriptBin "clickup" ''firefox --new-window "https://clickup.up.ac.za"'')
  ];
}