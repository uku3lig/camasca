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
  version = "2.5.2";

  src = fetchurl {
    url = "https://maven.fabricmc.net/cuchaz/enigma-swing/${finalAttrs.version}/enigma-swing-${finalAttrs.version}-all.jar";
    hash = "sha256-j4fqv6Ch7AZ9mBe+fDh0sXpkTY16EvQCUp4T5YhX8j0=";
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
