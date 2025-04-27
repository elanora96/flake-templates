{
  description = "Rust Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    rust-flake = {
      url = "github:juspay/rust-flake";
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
        };
    };
}
