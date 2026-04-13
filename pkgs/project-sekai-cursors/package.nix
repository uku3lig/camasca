{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  win2xcur,
  # options
  character ? "",
  animated ? false,
  # can be specified if the provided hashes do not suffice
  url ? null,
  hash ? null,
}:
let
  format = if animated then "ani" else "cur";
  suffix = if animated then "animated" else "static";

  data = (lib.importJSON ./hashes.json)."${character}-${format}";

  addmissing = fetchurl {
    url = "https://gist.githubusercontent.com/uku3lig/1a761983e4ae467009a682bea505a513/raw/80ff57a2f4866ede5984e34c48dba1413d1ad353/addmissing.sh";
    hash = "sha256-UTe3LKcmES6G1XHVvCN9Mvs3fVqaj0+bsv+0E33PmYk=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "project-sekai-cursors-${character}-${suffix}";
  version = "0";

  src = fetchurl {
    url = data.url or url;
    hash = data.hash or hash;
  };

  nativeBuildInputs = [
    unzip
    win2xcur
  ];

  unpackCmd = "unzip $src -d source";
  sourceRoot = "source";

  buildPhase = ''
    mkdir output/
    win2xcur *.{ani,cur} -o output

    pushd output
    mv Busy wait
    mv Diagonal1 size_fdiag
    mv Diagonal2 size_bdiag
    mv Help help
    mv Horizontal ew-resize
    mv Link pointer
    mv Move move
    mv Normal default
    mv Precision cross
    mv Text text
    mv Unavailable not-allowed
    mv Vertical ns-resize
    mv Working half-busy

    bash ${addmissing}
    popd
  '';

  installPhase = ''
    mkdir -p "$out/share/icons/${character}/cursors"
    cp output/{*,.*} "$out/share/icons/${character}/cursors"

    echo -e "[Icon Theme]\nName=${character}" > "$out/share/icons/${character}/index.theme"
    echo -e "[Icon Theme]\nInherits=${character}" > "$out/share/icons/${character}/cursor.theme"
  '';

  meta = {
    platforms = lib.platforms.all;
    hydraPlatforms = [ ];
  };
}
