{
  description = "Fraterna server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pumpkin.url = "git+https://github.com/Pumpkin-MC/Pumpkin.git?ref=0.2.0+26.3-26.51&submodules=1";
    fraterna.url = "github:mr-kitten25565/fraterna";
    fraterna-pkgs.url = "github:mr-kitten25565/fraterna-pkgs";
    fraterna.inputs.nixpkgs.follows = "nixpkgs";
    fraterna-pkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    pumpkin,
    fraterna,
    fraterna-pkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = fraterna.wrappers.pumpkin.wrap {
      inherit pkgs;
      package = pumpkin.packages.${system}.default;
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
          package = fraterna-pkgs.packages.${system}.hello-world;
          settings.greeting = "\n\nHi\n\n";
        }
        {
          package = fraterna-pkgs.packages.${system}.duels;
        }
      ];
    };

    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.default}/bin/pumpkin";
    };
  };
}
