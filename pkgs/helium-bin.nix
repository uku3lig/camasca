{
  stdenv,
  appimageTools,
  fetchurl,
}:
let
  arch = if stdenv.hostPlatform.isx86 then "x86_64" else "arm64";

  hashes = {
    x86_64-linux = "sha256-aJs8ayXmGSRpXDYOfhi4vgHlXBJ+nHQaCGMr9xibAYg=";
    aarch64-linux = "sha256-qaYnlaRaGSeO4s/CmjN4svo2nTyBh/of7OCYVXxYBJI=";
  };
in
appimageTools.wrapType2 (finalAttrs: {
  pname = "helium";
  version = "0.22.4.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${finalAttrs.version}/helium-${finalAttrs.version}-${arch}.AppImage";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/*.desktop -t $out/share/applications
    if [ -d ${finalAttrs.contents}/usr/share/icons ]; then
      cp -r ${finalAttrs.contents}/usr/share/icons $out/share/
    fi
    substituteInPlace $out/share/applications/*.desktop \
      --replace-quiet 'Exec=AppRun' 'Exec=helium'
  '';

  meta = {
    mainProgram = "helium";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
