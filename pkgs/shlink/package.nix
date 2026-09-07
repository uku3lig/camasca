{
  fetchFromGitHub,
  makeWrapper,
  php85,
}:
php85.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IZlsFfUm312EYHgKVAFIu6CCdVEcypD5lc1HxhI32+8=";
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
  vendorHash = "sha256-1tHxV7TZaMfkllsrkJZKHhLEPSqECLiXD7DVpfJNH0I=";

  postPatch = ''
    sed -i "s/%SHLINK_VERSION%/${finalAttrs.version}/g" module/Core/src/Config/Options/AppOptions.php
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
