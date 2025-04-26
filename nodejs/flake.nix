{
  description = "Nodejs Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.treefmt-nix.flakeModule ];
      perSystem =
        {
          pkgs,
          lib,
          ...
        }:
        let
          name = "Nodejs Template";
          pname = name;
          src = ./.;
          buildNpmPackage = pkgs.buildNpmPackage;
          importNpmLock = pkgs.importNpmLock;
          nodejs = pkgs.nodejs;

          meta = {
            description = "Nodejs Template";
            longDescription = ''
              A Nix Flake Template for Nodejs projects
            '';
            # homepage = "";
            license = lib.licenses.isc;
            # maintainers = with lib.maintainers; [ ];
            platforms = lib.platforms.all;
          };
        in
        {
          packages.default = buildNpmPackage {
            inherit
              name
              pname
              src
              meta
              ;
            npmDeps = importNpmLock { npmRoot = src; };
            npmConfigHook = importNpmLock.npmConfigHook;
            buildInputs = [ nodejs ];
            installPhase = ''
              mkdir -p $out
              cp -r ./build $out/build
            '';
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixfmt-rfc-style
            ];
            packages = [
              importNpmLock.hooks.linkNodeModulesHook
              nodejs
            ];
            npmDeps = importNpmLock.buildNodeModules {
              npmRoot = src;
              inherit nodejs;
            };
          };

          treefmt = {
            projectRootFile = "flake.nix"; # Used to find the project root
            programs = {
              biome = {
                enable = true;
                # settings.files.includes = [ "" ]; # Exclude files with ! as needed
              };
              mdformat.enable = true;
              nixfmt.enable = true;
            };
          };
        };
    };
}
