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

      perSystem = {pkgs, ...}: {
        packages = self.overlays.default {} pkgs;
        formatter = pkgs.alejandra;
      };

      flake = {
        overlays.default = import ./pkgs/all-packages.nix;

        nixosModules = {
          reposilite = import ./modules/reposilite.nix self;
        };
      };
    };
}
