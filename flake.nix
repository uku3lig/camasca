{
  description = "collection of uku's modules and packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      pkgsFor = system: import nixpkgs { inherit system; };
      forEachSystem = lib.genAttrs systems;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = pkgsFor system;
          isAvailable = name: drv: lib.meta.availableOn { inherit system; } drv;
          flakePkgs = self.overlays.default { } pkgs;
        in
        lib.filterAttrs isAvailable flakePkgs
      );

      overlays.default = import ./pkgs/all-packages.nix;

      nixosModules = {
        reposilite = import ./modules/reposilite.nix;
        asus-numpad = import ./modules/asus-numpad.nix self;
      };

      formatter = forEachSystem (system: (pkgsFor system).nixfmt-rfc-style);

      hydraJobs =
        let
          ciSystem = "x86_64-linux";
          isBuildable =
            name: drv:
            (!drv ? meta.hydraPlatforms)
            || lib.any (lib.meta.platformMatch { system = ciSystem; }) drv.meta.hydraPlatforms;

          packages = self.packages.${ciSystem};
        in
        lib.filterAttrs isBuildable packages;
    };
}
