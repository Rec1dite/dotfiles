# Mount network drive for user home directory on login
{ pkgs, ... }: {

  # TODO
  # # Mount the network drive on login
  # systemd.services.mount-home = {
  #   description = "Mount network drive for user home directory";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.coreutils}/bin/mount -t cifs -o username=techteam,password=5bae908c^,uid=1000,gid=1000 //
  #     aserv.ad.lab/techteam /mnt/home";
  #     ExecStop = "${pkgs.coreutils}/bin/umount /mnt/home";
  #   };
  # };

}