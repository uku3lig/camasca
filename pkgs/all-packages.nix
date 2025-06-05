final: prev: {
  asus-numpad = prev.callPackage ./asus-numpad.nix { };
  enigma = prev.callPackage ./enigma.nix { };
  jaspersoft-studio-community = prev.callPackage ./jaspersoft-studio-community.nix { };
  liberica-17 = prev.callPackage ./liberica.nix { };
  openwebstart = prev.callPackage ./openwebstart.nix { };
  project-sekai-cursors = prev.callPackage ./project-sekai-cursors/package.nix { };
  shlink = prev.callPackage ./shlink/package.nix { };
  sql-developer = prev.callPackage ./sql-developer.nix { };
  vineflower = prev.callPackage ./vineflower.nix { };
}
