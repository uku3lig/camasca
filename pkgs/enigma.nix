{
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "enigma";
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

  installPhase = with finalAttrs; ''
    runHook preInstall

    install -Dm644 $src $out/share/${name}/${name}.jar
    makeWrapper ${jdk}/bin/java $out/bin/${name} --add-flags "-jar $out/share/${name}/${name}.jar"

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
