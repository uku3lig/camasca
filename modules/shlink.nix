self:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.shlink;
  inherit (pkgs.stdenv.hostPlatform) system;

  basePath = "${cfg.package}/share/php/shlink";

  vars = builtins.map (a: "--set ${a.name} ${a.value}") (lib.attrsToList cfg.environment);
  varsStr = lib.concatStringsSep " " vars;
  wrappedPkg = pkgs.symlinkJoin {
    name = "shlink-wrapped";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/shlink ${varsStr}
    '';
  };
in
{
  options.services.shlink = {
    enable = lib.mkEnableOption "shlink";
    package = lib.mkPackageOption self.packages.${system} "shlink" { };
    roadrunnerPackage = lib.mkPackageOption pkgs "roadrunner" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Environment variables passed to the RoadRunner process";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.environment.DB_DRIVER ? "sqlite") != "sqlite";
        message = "sqlite is not supported. please set DB_DRIVER to one of the other supported values";
      }
    ];

    environment.systemPackages = [ wrappedPkg ];

    users = {
      groups.shlink = { };
      users.shlink = {
        isSystemUser = true;
        group = "shlink";
      };
    };

    systemd.services."shlink" = {
      wantedBy = [ "default.target" ];
      path = [ cfg.package.php ];
      environment = cfg.environment // {
        SHLINK_RUNTIME = "nixos"; # writes logs to stderr instead of a file inside the nix store
      };

      preStart = ''
        export SHELL_VERBOSITY=3
        cd ${basePath}
        php vendor/bin/shlink-installer init --no-interaction --clear-db-cache --skip-download-geolite
      '';

      serviceConfig = {
        Type = "notify";

        ExecStart = "${lib.getExe cfg.roadrunnerPackage} serve -c ${basePath}/config/roadrunner/.rr.yml";

        User = "shlink";
        Group = "shlink";

        StateDirectory = "shlink";

        KillMode = "mixed";
        TimeoutStopSec = 30;
        Restart = "always";
        RestartSec = 30;
      };
    };
  };
}
