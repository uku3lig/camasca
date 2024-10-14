{
  description = "collection of uku's modules and packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        lib,
        pkgs,
        system,
        ...
      }: {
        # output packages only if they are available on the system
        packages = let
          isAvailable = name: drv: lib.meta.availableOn {inherit system;} drv;
          flakePkgs = self.overlays.default {} pkgs;
        in
          lib.filterAttrs isAvailable flakePkgs;

        formatter = pkgs.alejandra;
      };

      flake = {
        overlays.default = import ./pkgs/all-packages.nix;

        nixosModules = {
          reposilite = import ./modules/reposilite.nix;
          asus-numpad = import ./modules/asus-numpad.nix self;
        };
      };
    };
}
