let
  pkgs = import <nixpkgs> {
    config = { };
    overlays = [ ];
  };
in
import ./pkgs/all-packages.nix { } pkgs
