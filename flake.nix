{
  description = "Fraterna server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pumpkin.url = "git+https://github.com/Pumpkin-MC/Pumpkin.git?ref=0.2.0+26.3-26.51&submodules=1";

    fraterna = {
      url = "github:mr-kitten25565/fraterna";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fraterna-pkgs = {
      url = "github:mr-kitten25565/fraterna-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
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
    packages.${system}.default = fraterna.wrappers.pumpkin.wrap ((import ./server.nix) {inherit pkgs fraterna fraterna-pkgs system pumpkin;});

    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.default}/bin/pumpkin";
    };
  };
}
