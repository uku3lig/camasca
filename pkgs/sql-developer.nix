{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  copyDesktopItems,
  fetchzip,
  file,
  gtk2-x11,
  gtk3,
  makeDesktopItem,
  makeWrapper,
  temurin-bin-17,
  xorg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sql-developer";
  version = "24.3.1.347.1826";

  src = fetchzip {
    url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-${finalAttrs.version}-no-jre.zip";
    hash = "sha256-y32TVnCuLhpHpo2nn8wOV1zV7nuRnBkApSxrOhx7wZg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    gtk2-x11
    gtk3
    temurin-bin-17
    xorg.libXxf86vm
  ];

  autoPatchelfIgnoreMissingDeps = [ "libav*" ];

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
