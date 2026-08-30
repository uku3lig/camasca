{
  lib,
  rustPlatform,
  cargo-tauri,
  fetchFromGitHub,
  libayatana-appindicator,
  makeWrapper,
  pkg-config,
  udev,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "girlglock-input-overlay";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "girlglock";
    repo = "input-overlay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ov8S1bTtUGBoa3oJbvZC7iAw6pZb0AyntrGsZjSrPT0=";
  };

  patches = [
    ./0001-fix-standardize-log-directory.patch
  ];

  cargoRoot = "ws-server/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-/s3ISnicV2yMToaewNbUeHlKhmKjzbNN1knNd/C2y1o=";

  nativeBuildInputs = [
    cargo-tauri.hook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libayatana-appindicator
    udev
    webkitgtk_4_1
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/input-overlay-ws \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ libayatana-appindicator ]}
  '';

  meta = {
    homepage = "https://overlay.girlglock.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
})
