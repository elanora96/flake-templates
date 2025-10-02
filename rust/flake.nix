{
  description = "Rust Template";

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
    rust-flake = {
      url = "github:juspay/rust-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.rust-flake.flakeModules.default
        inputs.rust-flake.flakeModules.nixpkgs
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];
      perSystem =
        {
          self',
          pkgs,
          ...
        }:
        let
          name = "Rust Template";
        in
        {
          rust-project = {
            src = ./.;

            crates.${name}.crane.args = {
              strictDeps = true;
              buildInputs = with pkgs; [
                pkg-config
              ];
              nativeBuildInputs = with pkgs; [
                pkg-config
              ];
            };
          };
          packages.default = self'.packages.${name};

          devShells.default = pkgs.mkShell {
            name = "${name}-shell";
            inputsFrom = [
              self'.devShells.rust
            ];
          };

          pre-commit.settings.hooks = {
            cargo-check.enable = true;
            clippy.enable = true;
            treefmt.enable = true;
          };

          treefmt = {
            projectRootFile = "flake.nix"; # Used to find the project root
            programs = {
              rustfmt = {
                enable = true;
                edition = "2024";
              };
              mdformat.enable = true;
              nixfmt.enable = true;
              taplo.enable = true;
            };
          };
        };
    };
}
