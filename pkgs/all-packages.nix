final: prev: {
  asus-numpad = prev.callPackage ./asus-numpad.nix { };
  enigma = prev.callPackage ./enigma.nix { };
  jaspersoft-studio-community = prev.callPackage ./jaspersoft-studio-community.nix { };
  openwebstart = prev.callPackage ./openwebstart.nix { };
  shlink = prev.callPackage ./shlink/package.nix { };
  undertalemodtool = prev.callPackage ./undertalemodtool/package.nix { };
  vineflower = prev.callPackage ./vineflower.nix { };
}
