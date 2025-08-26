{
  fetchFromGitHub,
  makeWrapper,
  php84,
}:
php84.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ut+yN8h9o+1NxwvDubq/AW3Vtkyb0VxYYp2kvdPzbIc=";
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
  vendorHash = "sha256-SVWL8nBDg9MXHZ+0Jhmci0lkpeLwYAgXn2FWoZC05q4=";

  postPatch = ''
    sed -i "s/%SHLINK_VERSION%/${finalAttrs.version}/g" module/Core/src/Config/Options/AppOptions.php
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
