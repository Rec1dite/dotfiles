# Mount the ActiveDirectory share via CIFS (SMB) protocol for internet access

{ pkgs, stdenv, ... }: {
  # Allow all users to execute the mnt-ad.sh script without a password
  security.sudo.extraConfig = ''
    ALL ALL=NOPASSWD: /usr/local/bin/mnt-ad.sh
  '';

  # Create the mnt-ad.sh script
  environment.systemPackages = with pkgs; [
    # See: [https://ryantm.github.io/nixpkgs/builders/trivial-builders/]
    # "writeShellApplication"
    (writeShellApplication {
      name = "mnt-ad";
      runtimeInputs = [];
      # See [builtins.readfile]
      text = ''
        # sudo mount -t cifs //prhwinad03/NETLOGON/ /mnt -o "domain=up"
        # sudo umount /mnt
      '';
      })

    # (
    #   stdenv.mkDerivation {
    #     name = "mnt-ad";

    #     mntAdSrc = lib.fileset.toSource {
    #       root = ./.;
    #       fileset = ./mnt-ad.sh;
    #     };

    #     installPhase = ''
    #       # TODO: Move script

    #       # ${prev.installPhase}
    #       # cp $themeSrc/Cr1m.ttheme $out/share/tauon/theme
    #       '';
    #     }
    # )
  ];
}