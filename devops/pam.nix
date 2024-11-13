# LDAP PAM login configuration
# See: [https://mt-caret.github.io/blog/posts/2020-07-25-ldap-client-with-nixos.html]

{ pkgs, lib, ... }:
let
  domain = "cs.up.ac.za";

  ldap_base_dn = "dc=cs,dc=up,dc=ac,dc=za";
  ldap_client_proto = "ldap";
  ldap_server = "nzvm3";

  home_server = "shodan.cs.up.ac.za";
  home_mng_port = 8123;

  hosts_no_static = [ "lab-image" ];

  concatStrs = lib.strings.concatStrings;
in {

  #--- Enable LDAP login ---#
  users.ldap = {
    enable = true;
    useTLS = true;
    timeLimit = 120; # Timeout after 2min

    # daemon.enable = true; # TODO: Investigate

    base = ldap_base_dn;
    server = concatStrs [ ldap_server "." domain ];

    extraConfig = ''
      ldap_version 3
      pam_password md5
    '';
  };

}