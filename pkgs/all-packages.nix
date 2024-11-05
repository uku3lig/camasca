final: prev: {
  enigma = prev.callPackage ./enigma.nix {};
  vineflower = prev.callPackage ./vineflower.nix {};
  koi = prev.kdePackages.callPackage ./koi.nix {};
  asus-numpad = prev.callPackage ./asus-numpad.nix {};
  openwebstart = prev.callPackage ./openwebstart.nix {};
}
