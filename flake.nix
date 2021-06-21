{
  description = "nix-darwin modules";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  };

  outputs = { self, nixpkgs }: {

    darwinModule = { ... }: {
      imports = [
        ./defaults/NSGlobalDomain.nix
        ./programs/mas
        ./services/mongodb
      ];
    };

  };
}
