#import "@preview/catppuccin:1.0.0": catppuccin, flavors, get-flavor

#let flavor = sys.inputs.at("flavor", default: flavors.mocha.identifier)
#let palette = get-flavor(flavor).colors.pairs().map(pair => (pair.at(0), pair.at(1).rgb)).to-dict()
#show: catppuccin.with(flavor)

#set page(height: auto, margin: 0.6in)
#set text(font: "FiraCode Nerd Font Mono", size: 1em)

#show raw: set text(fill: palette.blue, size: 1.2em, style: "italic")

#let slide-title(txt, pretxt: "") = {
  block(heading(
    text(pretxt, fill: palette.surface2, size: 1.6em, weight: "thin") + 
    text(if pretxt == "" { "" } else { " / "}, fill: palette.overlay2, size: 1.6em, font: "FiraCode Nerd Font Mono", weight: "medium") +
    text(txt, fill: rgb("#f43e5c"), size: 2em, font: "FiraCode Nerd Font Mono", weight: "medium")
  ), below: 25pt)
}

#let slide-subheading(txt) = block(heading(
  text(txt, fill: palette.peach, size: 1.4em), level: 2
), above: 28pt, below: 15pt)

#let slide-subsub(txt) = block(heading(
  text(fill: palette.green, size: 1.2em, txt), level: 2
), above: 24pt, below: 12pt)

#let slide-link(txt) = underline(text(txt,
  fill: palette.sky, style: "italic",
  size: 1.25em,
))

#let slide-images(..args, stroke: none) = {
  let imgs = args.pos().map(item => {
    let path = ""; let width = 100%
    if type(item) == array { (path, width) = item; }
    else { path = item }

    align(box(image(path, width: width), stroke: stroke), center)
  })
  align(grid(columns: imgs.len(), align: center + horizon, gutter: 10pt, ..imgs), center)
}


//==================================================//
#slide-title("Ricing")

- "*Ricing*": Pretentious over-customization of Japanese tuner cars

- *In Linux*: Aesthetic & functional desktop tweaking
  - Improved workflow & minimalism

#slide-subheading("Goal")

- Whirlwind tour of Linux ricing ecosystem
- Show what's possible
- Highlight modularity & freedom
- Share my approach

#slide-subsub("Holy grail")
#slide-link("https://reddit.com/r/unixporn")

#slide-subsub("Dotfiles")

#slide-link("https://github.com/rec1dite/dotfiles")


//==================================================//
#pagebreak()

#slide-images(
  "images/rice1.png",
)
#slide-images(
  "images/rice2.png",
  "images/rice3.jpg",
)
#slide-images(
  "images/rice4.png",
  "images/rice5.png",
  "images/rice6.png",
)

//==================================================//
#pagebreak()
#slide-title("Core Components", pretxt: "Desktop")

#slide-subheading("Display Server")
- Graphical system layer
- Renders applications to screen
- `Xorg` (legacy, mature)
- `Wayland` (modern)

#slide-images(
  ("images/xorg_logo.png", 40%),
  ("images/wayland_logo.png", 40%),
)

#slide-subheading("Desktop Environment")
- Complete software suite
- Includes file manager, panel, launcher, etc.
- `GNOME`, `KDE`, `XFCE`, `MATE`

#slide-images(
  ("images/gnome_logo.png", 50%),
  ("images/kde_logo.png", 40%),
  ("images/xfce_logo.svg", 40%),
  ("images/mate_logo.png", 40%)
)


//==================================================//
#pagebreak()
#slide-title("Window Management", pretxt: "Desktop")

#slide-subheading("Window Manager")
- Controls layout & behavior of windows
- Typically handles system keybinds
- Xorg-based:
  - `i3`, `AwesomeWM`, `DWM`, `QTile`, `XMonad`
- Wayland-based:
  - `Sway`, `Hyprland`

#slide-subheading("Compositor")
- Manages post-processing effects (transparency, shadows, animations)
  - `Picom`, `Xcompmgr`

#slide-subheading("System Tray")
- Holds background app icons
- `Trayer`, `Systray`


//==================================================//
#pagebreak()
#slide-title("Launchers & Panels", pretxt: "Desktop")

#slide-subheading("App Launcher")
- Alternative to Windows start menu
- Extensible fuzzy search + plugin support
- Popular options:
  - `Rofi`, `Dmenu`, `Albert` (Xorg)
  - `Wofi`, `Fuzzel` (Wayland)

#slide-subheading("Bar")
- Displays active workspaces, CPU usage, etc.
- `Polybar`, `Lemonbar`, `Xmobar`, `Eww`

#slide-subheading("Notification Daemon")
- Manages visual desktop notifications
- `Dunst`, `Mako`, `Notification Daemon`


//==================================================//
#pagebreak()
#slide-title("Terminals & Toolkits", pretxt: "Desktop")

#slide-subheading("Terminal Emulator")
- Your window to the command line
- `Kitty`, `XTerm`, `Alacritty`, `Cool Retro Term`

#slide-images(("images/terminals1.png", 80%))

#slide-subheading("GUI Toolkits")
- Define app look & feel
- `GTK` (used by GNOME), `QT` (used by KDE)
- Others: `wxWidgets`, `FLTK`


//==================================================//
#pagebreak()
#slide-title("XMonad", pretxt: "Window Manager")

#slide-subheading("Why XMonad?")
- Pure functional design in Haskell
- Tiling by default
- Scriptable layouts

#slide-subheading("Config")
- Defined in `xmonad.hs`
- Compile for changes to apply
- Integrate with xmobar/polybar

#align(image("images/xmonad_logo.svg", width: 30%), right)


//==================================================//
#pagebreak()
#slide-title("Polybar", pretxt: "Bar")

#slide-subheading("Overview")
- Lightweight & highly customizable bar
- Modules: `date`, `wifi`, `eth`, `battery`, `memory`, `workspaces`, `music`, `powermenu`

#slide-subheading("Integration")
- Connects via `dbus`
- Controlled via scripts or window manager

#slide-subheading("Workspaces")
- Workspace indicators with clickable actions
- Colors can reflect window state

// #slide-subheading("Layouts")
// - Icons/textual indicators
// - Dynamic switching


//==================================================//
#pagebreak()
#slide-title("NixOS", pretxt: "Distro")

#slide-subheading("Why NixOS?")
> `sudo nixos-rebuild switch`

- Declarative system config
- Reproducible environments
- Clean rollback support

#slide-subsub("Home Manager")
- User-level config
- Version-controlled dotfiles
- Unified with system settings

#slide-subsub("Stylix")
- Apply themes to system & apps
- Integrates with home-manager

#align(image("images/nixos_logo.png", width: 30%), right)

//==================================================//
#pagebreak()
#slide-title("Color & Themes")

#slide-subheading("Color Schemes")
- `Catppuccin`, `Dracula`, `Rosepine`
- `Tomorrow Night`, `Nord`, `One Dark`, `Horizon`

#slide-link("https://vscodethemes.com")

#slide-images(
  "images/catppuccin.svg",
  "images/dracula.svg",
  "images/rose_pine.svg",
  stroke: 2pt + palette.subtext1
)
#slide-images(
  "images/tomorrow_night.svg",
  "images/nord.svg",
  "images/one_dark.svg",
  "images/horizon.svg",
  stroke: 2pt + palette.subtext1
)

#slide-subheading("Browser Styling")
- `Stylus`: userstyles CSS overrides for specific websites

- `Dark Reader`: dynamic dark mode for all sites

- `Vimium`: Vim-based shortcuts for mouseless browsing


//==================================================//
#pagebreak()
#slide-title("Foundations")

#slide-subheading("Unix Core Philosophy")
- Freedom
  - Open source
  - Modular
  - Interoperable
  - Extensible
  - Minimalist

#slide-subsub("Where to Dive Deeper")
- *`r/unixporn`* -> #slide-link("https://reddit.com/r/unixporn")
  - Most posts have dotfiles available

- *`Arch Wiki`* -> #slide-link("https://wiki.archlinux.org")

- *`Namishh Ricing Guide`* -> #slide-link("https://namishh.me/blog/ricing")

#slide-subsub("Dotfiles")
#slide-link("https://github.com/rec1dite/dotfiles")