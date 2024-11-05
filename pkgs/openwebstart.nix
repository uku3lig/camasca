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
  pname = "OpenWebStart";
  version = "1.5.2";

  src = fetchurl {
    url = with finalAttrs; "https://github.com/karakun/OpenWebStart/releases/download/v${version}/OpenWebStart_linux_${builtins.replaceStrings ["."] ["_"] version}.deb";
    hash = "sha256-thB/JWbF/Xk/PLurwXvWwzQTyCeV1hU7Zm8BjrG6lS0=";
  };

  nativeBuildInputs = [dpkg makeWrapper copyDesktopItems];

  sourceRoot = "opt/OpenWebStart";

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp openwebstart.jar $out/lib/

    makeWrapper ${openjdk8}/bin/java $out/bin/openwebstart \
      --add-flags "-cp $out/lib/openwebstart.jar com.openwebstart.launcher.OpenWebStartLauncher"

    makeWrapper ${openjdk8}/bin/java $out/bin/openwebstart-settings \
      --add-flags "-cp $out/lib/openwebstart.jar com.openwebstart.launcher.ControlPanelLauncher"

    mkdir -p $out/share/pixmaps
    cp App-Icon-512.png $out/share/pixmaps/openwebstart-settings.png
    cp Icon-512.png $out/share/pixmaps/openwebstart.png
  '';

  dontBuild = true;
  dontCheck = true;

  desktopFiles = [
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
      mimeTypes = ["application/x-java-jnlp-file"];
    })
  ];

  meta.mainProgram = "openwebstart-settings";
})
