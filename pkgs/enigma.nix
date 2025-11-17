{
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "enigma";
  version = "4.0.2";

  src = fetchurl {
    url = "https://maven.fabricmc.net/cuchaz/enigma-swing/${finalAttrs.version}/enigma-swing-${finalAttrs.version}-all.jar";
    hash = "sha256-NuU2lfwUo12PAvOgibuHWGjf3TZbEchq+QdIf9KLl08=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/enigma.jar
    makeWrapper ${jdk}/bin/java $out/bin/enigma --add-flags "-jar $out/share/enigma.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "enigma";
      desktopName = "Enigma";
      exec = "enigma";
      terminal = false;
    })
  ];

  meta = {
    mainProgram = "enigma";
    inherit (jdk.meta) platforms;
  };
})
