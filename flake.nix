{
  inputs = { };

  outputs = { self, ... }: {
    nixosModules = {
      homecfg = import ./default.nix;
    };
  };
}
