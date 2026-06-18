{
  fetchFromGitHub,
  makeWrapper,
  php85,
}:
php85.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0wK3R64Tw1V+/lSrdWmARrHaaaUpM3UMOTOPXAZ43mw=";
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
  vendorHash = "sha256-xW5J8dSpeJFe6bdHBy/C+HSacY7b2fxxX9Gln0LK5h4=";

  postPatch = ''
    sed -i "s/%SHLINK_VERSION%/${finalAttrs.version}/g" module/Core/src/Config/Options/AppOptions.php
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
