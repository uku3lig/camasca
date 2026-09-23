{
  fetchFromGitHub,
  makeWrapper,
  php85,
}:
php85.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j3K4thh/HjeJaIVtgP42aug/rcdI+uuu3P9yJUFcaFA=";
  };

  patches = [ ./datadir.patch ];

  nativeBuildInputs = [ makeWrapper ];

  php = php85.withExtensions (
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
  vendorHash = "sha256-yS4D4v2MZMBXLDlCAdrGcjabEHGHy9QMf6Gpulac03A=";

  postPatch = ''
    sed -i "s/%SHLINK_VERSION%/${finalAttrs.version}/g" module/Core/src/Config/Options/AppOptions.php
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
