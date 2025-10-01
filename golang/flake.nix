{
  description = "GoLang Template";

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
          self',
          pkgs,
          lib,
          ...
        }:
        let
          name = "GoLang Template";
          pname = name;
          src = ./.;

          # Generate a user-friendly version number.
          version = builtins.substring 0 8 self'.lastModifiedDate;

          meta = {
            description = "GoLang Template";
            # longDescription = ''
            # '';
            # homepage = "";
            license = lib.licenses.isc;
            # maintainers = with lib.maintainers; [ ];
            platforms = lib.platforms.all;
          };
        in
        {
          packages.default = pkgs.buildGoModule {
            inherit
              name
              pname
              src
              version
              meta
              ;
            vendorHash = pkgs.lib.fakeHash; # TODO: Get real vendorHash
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              gopls
              gotools
              go-tools
            ];
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              gofmt.enable = true;
              mdformat.enable = true;
              nixfmt.enable = true;
            };
          };
        };
    };
}
