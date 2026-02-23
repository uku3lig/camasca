{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  cairo,
  cups,
  fetchurl,
  freetype,
  glib,
  gtk3,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  makeWrapper,
  setJavaClassPath,
  zlib,
}:
let
  runtimeLibs = [
    cups
    gtk3
    glib
    cairo
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "liberica-jdk-bin";
  version = "17.0.18+10";

  src = fetchurl {
    url = "https://download.bell-sw.com/java/${finalAttrs.version}/bellsoft-jdk${finalAttrs.version}-linux-amd64.tar.gz";
    hash = "sha256-uJ7yaEcewFxyFx0D+84A+Z9t+HzaBH7AZFyxwSQhMfg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    freetype
    libx11
    libxext
    libxi
    libxrender
    libxtst
    zlib
  ];

  installPhase = ''
    runHook preInstall

    cd ..
    mv $sourceRoot $out

    # jni.h expects jni_md.h to be in the header search path.
    ln -s $out/include/linux/*_md.h $out/include/

    # Remove some broken manpages.
    # Only for 11 and earlier.
    [ -e "$out/man/ja" ] && rm -r $out/man/ja*

    # Remove embedded freetype to avoid problems like
    # https://github.com/NixOS/nixpkgs/issues/57733
    find "$out" -name 'libfreetype.so*' -delete

    # Propagate the setJavaClassPath setup hook from the JDK so that
    # any package that depends on the JDK has $CLASSPATH set up
    # properly.
    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> "$out/nix-support/setup-hook"
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF

    # We cannot use -exec since wrapProgram is a function but not a command.
    #
    # jspawnhelper is executed from JVM, so it doesn't need to wrap it, and it
    # breaks building OpenJDK (#114495).
    for bin in $( find "$out" -executable -type f -not -name jspawnhelper ); do
      if patchelf --print-interpreter "$bin" &> /dev/null; then
        wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
      fi
    done

    runHook postInstall
  '';

  meta = {
    mainProgram = "java";
    platforms = lib.platforms.linux;
  };
})
