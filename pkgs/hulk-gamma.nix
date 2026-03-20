{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "hulk-gamma";
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "Chiffario";
    repo = "hulk";
    rev = "0b43818735439585ab5697d5ed356fdcff9221ee";
    hash = "sha256-xNFdfxhySVLFqQRLtgcdAmvv9fw6KBJqkhN6VyBTt+8=";
  };

  cargoHash = "sha256-X07n4QbSs/s1GMha3QAyTyplKptiHDFaB6dQ5aw6VTw=";

  meta = {
    description = "Small IPC-based CLI for gamma controls on Wayland";
    homepage = "https://github.com/Chiffario/hulk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "hulk";
  };
}
