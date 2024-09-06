## To setup:
1. Clone into `~/.dotfiles`

2. Add the following symlinks on a new install to avoid having to add the `--flake .` option to `nixos-rebuild switch` and `home-manager switch` every time:
- `/etc/nixos/flake.nix` ⇢ `~/.dotfiles/flake.nix`
- `~/.config/home-manager/flake.nix` ⇢ `~/.dotfiles/flake.nix`

> All other files in `/etc/nixos/` and `~/.config/home-manager/` may be removed.



### Additional configs:
```bash
# Keyboard laser effect
asusctl led-mode laser -s high -c ff0205
```