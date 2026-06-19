{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:
buildDotnetModule (finalAttrs: {
  pname = "jellyfin-pgsql";
  version = "10.11.11-1";

  src = fetchFromGitHub {
    owner = "JPVenson";
    repo = "Jellyfin.Pgsql";
    tag = finalAttrs.version;
    hash = "sha256-qOh3Ij0uGrEPbz+t/Dn9MgMX4n0TVhUrcD7OPNQcbCk=";
  };

  projectFile = "Jellyfin.Plugin.Pgsql.sln";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  postPatch = ''
    echo "dotnet_diagnostic.CA1707.severity = none" >> .editorconfig
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
})
