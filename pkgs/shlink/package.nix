{
  fetchFromGitHub,
  makeWrapper,
  php84,
}:
php84.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tj0SJYOYQHZl+FlWPTG3AXYhCA1qy2Yq2Zq47wm4x6Y=";
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
  vendorHash = "sha256-Q5xSsUh5s4qlEp+PNBtdsfOND0GpcMUPnnJmT4EMS8w=";

  postPatch = ''
    sed -i "s/%SHLINK_VERSION%/${finalAttrs.version}/g" module/Core/src/Config/Options/AppOptions.php
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
