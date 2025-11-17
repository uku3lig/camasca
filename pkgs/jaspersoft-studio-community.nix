{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  copyDesktopItems,
  gtk3,
  makeDesktopItem,
  requireFile,
  temurin-bin-17,
  wrapGAppsHook3,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jaspersoft-studio-community";
  version = "6.21.5";

  src = requireFile {
    name = "js-studiocomm_${finalAttrs.version}_linux_x86_64.tgz";
    url = "https://community.jaspersoft.com/download-jaspersoft/community-edition/jaspersoft-studio_${finalAttrs.version}";
    hash = "sha256-PnMIc2HvGF+qdeuqPmua3XYh3KhnSQuPN9Ugg/Hfvn0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    rm -rf features/jre.linux.gtk.x86_64.feature_17.0.8.1_1/eclipsetemurin_jre
    ln -s ${temurin-bin-17} features/jre.linux.gtk.x86_64.feature_17.0.8.1_1/eclipsetemurin_jre

    mkdir -p $out/share/jaspersoft-studio-community
    cp -r . $out/share/jaspersoft-studio-community

    install -Dm644 icon.xpm $out/share/pixmaps/jaspersoft-studio-community.xpm

    mkdir -p $out/bin
    ln -s "$out/share/jaspersoft-studio-community/Jaspersoft Studio" $out/bin/jaspersoft-studio-community

    runHook postInstall
  '';

  preFixup = ''
    wrapGApp "$out/share/jaspersoft-studio-community/Jaspersoft Studio"
  '';

  dontBuild = true;
  dontCheck = true;
  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "JasperSoft Studio Community";
      type = "Application";
      desktopName = "JasperSoft Studio Community";
      exec = "jaspersoft-studio-community";
      icon = "jaspersoft-studio-community";
    })
  ];

  meta = {
    mainProgram = "jaspersoft-studio-community";
    inherit (temurin-bin-17.meta) platforms;
    hydraPlatforms = [ ];
    broken = lib.versionAtLeast gtk3.version "3.24.44" && lib.versionOlder gtk3.version "3.24.51";
  };
})
