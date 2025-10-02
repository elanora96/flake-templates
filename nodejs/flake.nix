{
  description = "Nodejs Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];
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
          npmRoot = src;

          inherit (pkgs) importNpmLock nodejs;

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

          buildInputs = [ nodejs ];
        in
        {
          packages.default = pkgs.buildNpmPackage {
            inherit
              name
              pname
              src
              meta
              buildInputs
              ;

            npmDeps = importNpmLock { inherit npmRoot; };
            inherit (importNpmLock) npmConfigHook;

            installPhase = ''
              mkdir -p $out
              cp -r ./build $out/build
            '';
          };

          devShells.default = pkgs.mkShell {
            inherit buildInputs;
            name = "${name}-shell";
            packages = [
              importNpmLock.hooks.linkNodeModulesHook
              nodejs
            ];
            npmDeps = importNpmLock.buildNodeModules {
              inherit nodejs npmRoot;
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
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
