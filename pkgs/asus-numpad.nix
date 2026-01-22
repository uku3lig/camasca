{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libevdev,
}:
rustPlatform.buildRustPackage {
  pname = "asus-numpad";
  version = "0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "iamkroot";
    repo = "asus-numpad";
    rev = "87900f8c00a3860e659812cd42f9439e529f8c2e";
    hash = "sha256-XtYM04c6dolO77neyAKBHBrx5smaPlLSjPM7+F1ko4Q=";
  };

  cargoHash = "sha256-RdLTYFK5ei7VDBsRwcScQIPaJ6DdnNmgE8pl3DVQhYs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libevdev
  ];

  meta = with lib; {
    mainProgram = "asus-numpad";
    description = "Linux driver for Asus laptops to activate numpad on touchpad";
    homepage = "https://github.com/iamkroot/asus-numpad";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
