self:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.asus-numpad;
  inherit (pkgs.stdenv.hostPlatform) system;

  toml = pkgs.formats.toml { };
in
{
  options.services.asus-numpad = {
    enable = lib.mkEnableOption "asus-numpad";
    package = lib.mkPackageOption self.packages.${system} "asus-numpad" { };

    settings = lib.mkOption {
      description = "Options for the configuration file located at /etc/xdg/asus_numpad.toml. See https://github.com/iamkroot/asus-numpad#configuration";
      example = {
        layout = "M433IA";
      };
      type = lib.types.submodule {
        freeformType = toml.type;

        options.layout = lib.mkOption {
          description = "Numpad key layout.";
          type = lib.types.enum [
            "UX433FA"
            "M433IA"
            "UX581"
            "GX701"
            "GX531"
            "G533"
          ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      i2c.enable = true;
      uinput.enable = true;
    };

    environment.etc."xdg/asus_numpad.toml".source = toml.generate "asus_numpad.toml" cfg.settings;

    systemd.services.asus-numpad = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        TimeoutSec = "5s";
      };
    };
  };
}
