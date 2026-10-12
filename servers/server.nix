{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    packages.default = inputs.fraterna.wrappers.pumpkin.wrap {
      inherit pkgs;
      package = inputs.pumpkin.packages.${system}.default;
      settings = {
        networking = {
          java = {
            enabled = true;
            online_mode = false;
            encryption = false;
            address = "0.0.0.0:25565";
          };
          bedrock.enabled = false;
        };
      };
      plugins = [
        {
          package = inputs.fraterna-pkgs.packages.${system}.hello-world;
          settings.greeting = "\n\nHi\n\n";
        }
        {
          package = inputs.fraterna-pkgs.packages.${system}.duels;
        }
      ];
    };
  };
}
