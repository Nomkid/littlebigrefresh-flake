{
  description = "LittleBigPlanet Refresher";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      version = "1.5.0";
      runtimeDeps = with pkgs; [
        # libz
        # stdenv.cc.cc.lib
        icu
        gtk3
        glib
        gsettings-desktop-schemas
        libnotify
      ];

      refresher = pkgs.buildDotnetModule rec {
        pname = "Refresher";
        inherit version runtimeDeps;

        src = pkgs.fetchFromGitHub {
          owner = "LittleBigRefresh";
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-NLKGaHQ2wGBJ9WXtc2WvvdqaFIVDD5z9ArUtaF/cKZA=";
        };

        nugetDeps = ./deps.nix;
        
        dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
        dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

        projectFile = "Refresher/Refresher.csproj";
      };
    in {
      packages = {
        refresher = refresher;
        default = refresher;
      };
    });
}
