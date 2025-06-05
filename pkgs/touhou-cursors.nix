{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  character ? "",
}:
stdenvNoCC.mkDerivation {
  pname = "touhou-cursors-${character}";
  version = "0";

  src = fetchFromGitHub {
    owner = "mabequinho";
    repo = "touhou-cursors";
    rev = "92a5513c5d247fb1813e27ac2986e85def510204";
    hash = "sha256-XYmEpRkvZK7O9F7s3nKFA9rd7xO0ECEWlVyUb8/whq4=";
  };

  installPhase =
    if character == "" then
      ''
        rm README.md
        echo "No character provided, please override the package with one of the available characters (eg. 'touhou-cursors.override { character = \"Patchouli\";}')"
        echo *
        exit 1
      ''
    else
      ''
        mkdir -p $out/share/icons
        cp -r ${character} $out/share/icons
      '';

  meta = {
    platforms = lib.platforms.all;
    hydraPlatforms = [ ];
  };
}
