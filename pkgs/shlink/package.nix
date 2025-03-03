{
  fetchFromGitHub,
  makeWrapper,
  php84,
}:
php84.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "4.4.5";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ETj3bW2wo9WcNYVBJ+heLFJ99+tDVwTfeXQWJGeoZHM=";
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
  vendorHash = "sha256-ToFl7c+yrT+K30BZWKnPqtfcna6Rcae/+MCxKZouWlw=";

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
