{
  description = "elanora96's Flake Templates";

  outputs =
    { self }:
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
      templates = {
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
}
