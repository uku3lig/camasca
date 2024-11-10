{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.reposilite;
in {
  options.services.reposilite = {
    enable = lib.mkEnableOption "reposilite";
    package = lib.mkPackageOption pkgs "reposilite" {};
    environmentFile = lib.mkOption {
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)`
      '';
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''
        "/run/agenix.d/1/reposilite"
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users.reposilite = {
        isSystemUser = true;
        group = "reposilite";
      };

      groups.reposilite = {};
    };

    systemd.services."reposilite" = {
      enable = true;
      wantedBy = lib.mkDefault ["multi-user.target"];
      after = lib.mkDefault ["network.target"];
      script = ''
        ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        StateDirectory = "reposilite";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/reposilite";

        User = "reposilite";
        Group = "reposilite";

        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };
  };
}
