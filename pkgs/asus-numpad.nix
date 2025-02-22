{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libevdev,
}:
rustPlatform.buildRustPackage {
  pname = "asus-numpad";
  version = "unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "iamkroot";
    repo = "asus-numpad";
    rev = "e78875c1f4c58e06199737f4ef5c6f48ac7cb21b";
    hash = "sha256-5FqM80zUDucDA0VocJ7ODmKAC6gcd9QwBOHVVKa6iMI=";
  };

  cargoHash = "sha256-pysUNC7ZKM7HewzQx0i0FPCHcm5TOt6pORmgOKmqIWQ=";
  useFetchCargoVendor = true;

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
