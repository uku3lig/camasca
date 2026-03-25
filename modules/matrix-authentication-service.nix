# https://github.com/NixOS/nixpkgs/pull/387274
import (
  builtins.fetchurl {
    url = "https://github.com/teutat3s/nixpkgs/raw/c3fcdfde109b6cc9ab4b82e73d9bdf82e9ff2324/nixos/modules/services/matrix/matrix-authentication-service.nix";
    sha256 = "sha256:0x7jjw95glyi8mjfr9ncl5zkq7j5kh01f18rh020kyn2ans4whgm";
  }
)
