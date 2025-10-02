{
  description = "elanora96's Flake Templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Used for pre-commit hooks
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Prefered Flake framework of the author
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # Simple list of default systems
    systems.url = "github:nix-systems/default";
    # Nixifys treefmt for easy flake usage
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
      perSystem = _: {
        pre-commit.settings.hooks = {
          treefmt.enable = true;
        };

        treefmt = {
          projectRootFile = ".gitignore";
          programs = {
            mdformat.enable = true;
            nixfmt.enable = true;
            statix.enable = true;
          };
        };
      };
      flake = _: {
        templates =
          let
            mkWelcomeText =
              {
                name,
                description,
                path,
                buildTools ? null,
                additionalSetupInfo ? null,
              }:
              {
                inherit path;

                description = name;

                welcomeText = ''
                  # ${name}
                  ${description}

                  ${
                    if buildTools != null then
                      ''
                        Comes bundled with:
                        ${builtins.concatStringsSep ", " buildTools}
                      ''
                    else
                      ""
                  }
                  ${
                    if additionalSetupInfo != null then
                      ''
                        Additional setup:
                        ${builtins.concatStringsSep ",\n" additionalSetupInfo}
                      ''
                    else
                      ""
                  }
                '';
              };
          in
          {
            golang = mkWelcomeText {
              path = ./golang;
              name = "GoLang Template";
              description = "A basic GoLang Template";
              buildTools = [
                "go"
                "gopls"
                "gotools"
                "buildGoModule"
              ];
              additionalSetupInfo = [
                "Remember to give a real vendorHash!"
              ];
            };
            nodejs = mkWelcomeText {
              path = ./nodejs;
              name = "Nodejs Template";
              description = "A basic Nodejs Template";
              buildTools = [
                "Nodejs"
                "buildNpmPackage"
                "importNpmLock"
              ];
              additionalSetupInfo = [
                "run npm init or similar project creation script"
              ];
            };
            rust = mkWelcomeText {
              path = ./rust;
              name = "Rust Template";
              description = "A basic Rust Template";
              buildTools = [
                "Standard Rust tools"
                "Crane"
                "Rust Flake"
              ];
              additionalSetupInfo = [
                "run cargo new or similar project creation script"
              ];
            };
            zola-nodejs = mkWelcomeText {
              path = ./zola-nodejs;
              name = "Zola Nodejs Template";
              description = "A basic Zola and Nodejs Enviroment Template";
              buildTools = [
                "Zola"
                "Nodejs"
                "buildNpmPackage"
                "importNpmLock"
              ];
              additionalSetupInfo = [
                "MUST PROVIDE NPM BUILD SCRIPT"
              ];
            };
          };
      };
    };
}
