{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "helium";
  version = "0.16.5.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${finalAttrs.version}/helium-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-N6+wwg46ufsbCqEJv/WpTWDCnI3tnFt58cG6TsGxXew=";
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
    platforms = [ "x86_64-linux" ];
  };
})
