{
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  dpkg,
  openjdk8,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openwebstart";
  version = "1.13.0";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://github.com/karakun/OpenWebStart/releases/download/v${version}/OpenWebStart_linux_${
        builtins.replaceStrings [ "." ] [ "_" ] version
      }.deb";
    hash = "sha256-q9XZlTt1nflylvNPWyXxh0zvY3Nm+8e481cic3xUWso=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    copyDesktopItems
  ];

  unpackCmd = "dpkg-deb -x $src .";
  sourceRoot = "opt/OpenWebStart";

  installPhase = ''
    runHook preInstall

    install -Dm644 openwebstart.jar -t $out/lib

    install -Dm644 App-Icon-512.png $out/share/pixmaps/openwebstart-settings.png
    install -Dm644 Icon-512.png $out/share/pixmaps/openwebstart.png

    makeWrapper ${openjdk8}/bin/java $out/bin/openwebstart \
      --add-flags "-cp $out/lib/openwebstart.jar com.openwebstart.launcher.OpenWebStartLauncher"

    makeWrapper ${openjdk8}/bin/java $out/bin/openwebstart-settings \
      --add-flags "-cp $out/lib/openwebstart.jar com.openwebstart.launcher.ControlPanelLauncher"

    runHook postInstall
  '';

  dontBuild = true;
  dontCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "OpenWebStart Settings";
      type = "Application";
      desktopName = "OpenWebStart Settings";
      exec = "openwebstart-settings %U";
      icon = "openwebstart-settings";
    })

    (makeDesktopItem {
      name = "OpenWebStart";
      type = "Application";
      desktopName = "OpenWebStart";
      noDisplay = true;
      exec = "openwebstart %f";
      icon = "openwebstart-settings";
      mimeTypes = [ "application/x-java-jnlp-file" ];
    })
  ];

  meta = {
    mainProgram = "openwebstart-settings";
    inherit (openjdk8.meta) platforms;
  };
})
