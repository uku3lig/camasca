final: prev: {
  asus-numpad = prev.callPackage ./asus-numpad.nix { };
  enigma = prev.callPackage ./enigma.nix { };
  glfw3-waywall = prev.callPackage ./glfw3-waywall/package.nix { };
  jaspersoft-studio-community = prev.callPackage ./jaspersoft-studio-community.nix { };
  liberica-17 = prev.callPackage ./liberica.nix { };
  openwebstart = prev.callPackage ./openwebstart.nix { };
  project-sekai-cursors = prev.callPackage ./project-sekai-cursors/package.nix { };
  shlink = prev.callPackage ./shlink/package.nix { };
  sql-developer = prev.callPackage ./sql-developer.nix { };
  touhou-cursors = prev.callPackage ./touhou-cursors.nix { };
  vineflower = prev.callPackage ./vineflower.nix { };
}
