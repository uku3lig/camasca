{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:
buildDotnetModule rec {
  pname = "undertalemodtool";
  version = "0.7.0.0";

  src = fetchFromGitHub {
    owner = "UnderminersTeam";
    repo = "UndertaleModTool";
    tag = version;
    hash = "sha256-Ya7M+CBbto/3X0CZbG15XX96i0+bXh9Qxr25dlSXO/8=";
  };

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0-bin;

  dotnetRestoreFlags = "UndertaleModCli";
  dotnetBuildFlags = "UndertaleModCli --no-restore";
  dotnetInstallFlags = "UndertaleModCli";

  meta.mainProgram = "UndertaleModCli";
}
