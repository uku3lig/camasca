{
  fetchFromGitHub,
  makeWrapper,
  php84,
}:
php84.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dAiEX5ZAuoaPRDUKw3dROeJG1wQYp+BSdMgN6P8eIFw=";
  };

  patches = [ ./datadir.patch ];

  nativeBuildInputs = [ makeWrapper ];

  php = php84.withExtensions (
    { enabled, all }:
    enabled
    ++ (with all; [
      # json
      curl
      pdo
      intl
      gd
      gmp
      sockets
      bcmath
    ])
  );

  composerLock = ./composer.lock;
  vendorHash = "sha256-sTzLB9ksvmgm729BPSreDsrXFn+bH31kbUlIzsSeP0c=";

  postPatch = ''
    sed -i "s/%SHLINK_VERSION%/${finalAttrs.version}/g" module/Core/src/Config/Options/AppOptions.php
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
