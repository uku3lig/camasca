final: prev: {
  asus-numpad = prev.callPackage ./asus-numpad.nix { };
  enigma = prev.callPackage ./enigma.nix { };
  jaspersoft-studio-community = prev.callPackage ./jaspersoft-studio-community.nix { };
  json2cdn = prev.callPackage ./json2cdn/package.nix { };
  koi = prev.kdePackages.callPackage ./koi.nix { };
  openwebstart = prev.callPackage ./openwebstart.nix { };
  vineflower = prev.callPackage ./vineflower.nix { };
}
