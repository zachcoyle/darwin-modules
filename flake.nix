{
  description = "some extra nix-darwin modules";

  outputs = _: {
    darwinModule = {...}: {
      imports = [
        ./defaults/NSGlobalDomain.nix
        ./programs/mas
        ./services/mongodb
      ];
    };
  };
}
