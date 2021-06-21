{
  description = "nix-darwin modules";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  };

  outputs = { self, nixpkgs }: {

    darwinModule = { ... }: {
      imports = [
        ./services/mongodb
        ./programs/mas
      ];
    };

  };
}
