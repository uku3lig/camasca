{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  gtk3,
  makeDesktopItem,
  requireFile,
  temurin-bin-17,
  wrapGAppsHook3,
}:
let
  # swt breaks with gtk3 >= 3.24.44
  oldGtk3 = gtk3.overrideAttrs rec {
    version = "3.24.43";
    src = fetchurl {
      url = "mirror://gnome/sources/gtk+/${lib.versions.majorMinor version}/gtk+-${version}.tar.xz";
      hash = "sha256-fgTwZIUVA0uAa3SuXXdNh8/7GiqWxGjLW+R21Rvy88c=";
    };
  };

  oldwrap = wrapGAppsHook3.override { gtk3 = oldGtk3; };
  oldjdk = temurin-bin-17.override { gtk3 = oldGtk3; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jaspersoft-studio-community";
  version = "6.21.3";

  src = requireFile {
    name = "js-studiocomm_${finalAttrs.version}_linux_x86_64.tgz";
    url = "https://community.jaspersoft.com/download-jaspersoft/community-edition/jaspersoft-studio_${finalAttrs.version}";
    hash = "sha256-llxWq2hNTlHC2slhov0VDK2mJu2NZ2xOh3Rut9XDKac=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    oldwrap
  ];

  installPhase = ''
    runHook preInstall

    rm -rf features/jre.linux.gtk.x86_64.feature_17.0.8.1_1/eclipsetemurin_jre
    ln -s ${oldjdk} features/jre.linux.gtk.x86_64.feature_17.0.8.1_1/eclipsetemurin_jre

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
  };
})
