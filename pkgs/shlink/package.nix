{
  fetchFromGitHub,
  makeWrapper,
  php84,
}:
php84.buildComposerProject (finalAttrs: {
  pname = "shlink";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "shlinkio";
    repo = "shlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7at90bmeJNQUh8tmIBpspSjMw7zaYqFNOfs8EIxOLUg=";
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
  vendorHash = "sha256-hQi+1JqL0t/SfBZQqrtQbIO46/MHLbfN3z4q06G6hfE=";

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/php/shlink/bin/cli $out/bin/shlink
  '';
})
