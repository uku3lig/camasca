final: prev: {
  enigma = prev.callPackage ./enigma.nix {};
  vineflower = prev.callPackage ./vineflower.nix {};
  koi = prev.kdePackages.callPackage ./koi.nix {};

  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };
}
