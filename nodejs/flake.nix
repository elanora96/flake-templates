{
  description = "Nodejs Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
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
          nodejs = pkgs.nodejs_23;

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
        };
    };
}
