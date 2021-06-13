{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mongodb;

  mongoCnf = cfg:
    ''
      net.bindIp: ${cfg.bind_ip}
      ${optionalString cfg.quiet "systemLog.quiet: true"}
      systemLog.destination: syslog
      storage.dbPath: ${cfg.dbpath}
      ${optionalString cfg.enableAuth "security.authorization: enabled"}
      ${optionalString (cfg.replSetName != "") "replication.replSetName: ${cfg.replSetName}"}
      ${cfg.extraConfig}
    '';
in
{
  options.services.mongodb = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the mongodb database service.";
    };

    package = mkOption {
      type = types.path;
      default = pkgs.mongodb;
      defaultText = "pkgs.mongodb";
      description = "This option specifies the mongodb package to use";
    };


    bind_ip = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "IP to bind to";
    };


    quiet = mkOption {
      type = types.bool;
      default = false;
      description = "quieter output";
    };

    enableAuth = mkOption {
      type = types.bool;
      default = false;
      description = "Enable client authentication. Creates a default superuser with username root!";
    };

    initialRootPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Password for the root user if auth is enabled.";
    };

    dbpath = mkOption {
      type = types.str;
      default = "/var/db/mongodb";
      description = "Location where MongoDB stores its files";
    };

    # pidFile = mkOption {
    #   type = types.str;
    #   default = "/run/mongodb.pid";
    #   description = "Location of MongoDB pid file";
    # };

    replSetName = mkOption {
      type = types.str;
      default = "";
      description = ''
        If this instance is part of a replica set, set its name here.
        Otherwise, leave empty to run as single node.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional text to be appended to <filename>mongod.conf</filename>";
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.mongodb = {
      command = "${cfg.package}/bin/mongod -f /etc/mongod.conf";
      serviceConfig.KeepAlive = true;
    };

    environment.etc."mongod.conf".text = mongoCnf cfg;

  };
}
