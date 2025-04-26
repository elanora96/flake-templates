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
        nodejs = mkWelcomeText {
          path = ./nodejs;
          name = "Nodejs Template";
          description = "A basic Nodejs Template";
          buildTools = [
            "Nodejs"
          ];
          additionalSetupInfo = [
            "run npm init or similar project creation script"
          ];
        };
      };
    };
}
