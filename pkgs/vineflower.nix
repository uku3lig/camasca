{
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vineflower";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/Vineflower/vineflower/releases/download/${finalAttrs.version}/vineflower-${finalAttrs.version}.jar";
    hash = "sha256-phXQfdu81Ik2lnT0DkLfY5wyvpVBCJCzjxc9XB4uo5w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/vineflower.jar
    makeWrapper ${jre_headless}/bin/java $out/bin/vineflower --add-flags "-jar $out/share/vineflower.jar"

    runHook postInstall
  '';

  meta = {
    mainProgram = "vineflower";
    inherit (jre_headless.meta) platforms;
  };
})
