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

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    isNixModule = file:
      file.hasExt "nix"
      && file.name != "flake.nix"
      && !lib.hasPrefix "_" file.name;

    importTree = path:
      toList (fileFilter isNixModule path);

    mkFlake = inputs.flake-parts.lib.mkFlake {inherit inputs;};
  in
    mkFlake {imports = importTree ./.;};
}
