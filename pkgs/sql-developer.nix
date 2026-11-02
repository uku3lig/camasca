{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  copyDesktopItems,
  fetchzip,
  file,
  gtk3,
  libxxf86vm,
  makeDesktopItem,
  makeWrapper,
  temurin-bin-17,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sql-developer";
  version = "26.2.0.186.2220";

  src = fetchzip {
    url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-${finalAttrs.version}-no-jre.zip";
    hash = "sha256-2krtyGbUgl4AuaCPWfSqpg9mTCIYn7Jk8jKEIgfK1ac=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    gtk3
    libxxf86vm
    temurin-bin-17
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libav*"
    "libgtk-x11-2.0*"
    "libgdk-x11-2.0*"
  ];

  postBuild = ''
    echo "AddVM9OrHigherOption --add-exports=java.desktop/com.sun.java.swing.plaf.gtk=ALL-UNNAMED" >> ide/bin/jdk.conf
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sql-developer
    cp -r {,.}* $out/share/sql-developer/

    install -Dm644 icon.png $out/share/pixmaps/sql-developer.png

    makeWrapper $out/share/sql-developer/sqldeveloper.sh $out/bin/sql-developer \
      --set JAVA_HOME ${temurin-bin-17} \
      --prefix PATH : ${lib.makeBinPath [ file ]}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sql-developer";
      desktopName = "Oracle SQL Developer";
      type = "Application";
      exec = "sql-developer %U";
      icon = "sql-developer";
    })
  ];

  meta.mainProgram = "sql-developer";
})
