{
  pkgs ? import <nixpkgs> { },
}:
import ./pkgs/all-packages.nix { } pkgs
