{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  win2xcur,
  # options
  group ? "",
  animated ? false,
  # can be specified if the provided hashes do not suffice
  hash ? null,
}:
let
  format = if animated then "ani" else "cur";
  suffix = if animated then "animation" else "static";

  hashes = lib.importJSON ./hashes.json;

  addmissing = fetchurl {
    url = "https://gist.githubusercontent.com/uku3lig/1a761983e4ae467009a682bea505a513/raw/80ff57a2f4866ede5984e34c48dba1413d1ad353/addmissing.sh";
    hash = "sha256-UTe3LKcmES6G1XHVvCN9Mvs3fVqaj0+bsv+0E33PmYk=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "project-sekai-cursors-${group}-${suffix}";
  version = "0";

  src = fetchurl {
    url = "https://www.colorfulstage.com/upload_images/media/Download/${format}%20file-${suffix}-${group}.zip";
    hash = hashes."${group}-${format}" or hash;
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
    mkdir -p "$out/share/icons/${group} Miku/cursors"
    cp output/{*,.*} "$out/share/icons/${group} Miku/cursors"

    echo -e "[Icon Theme]\nName=${group} Miku" > "$out/share/icons/${group} Miku/index.theme"
    echo -e "[Icon Theme]\nInherits=${group} Miku" > "$out/share/icons/${group} Miku/cursor.theme"
  '';

  meta = {
    platforms = lib.platforms.all;
    hydraPlatforms = [ ];
  };
}
