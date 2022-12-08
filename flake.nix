{
  inputs = {
      packer-nvim = { url = "github:wbthomason/packer.nvim"; flake = false; };
    };

  outputs = { self, ... }: {
    nixosModules = {
      homecfg = import ./default.nix;
      nvim-packer = { config, lib, pkgs, ... }:
        let
          packer_dir     = ".local/share/nvim/site/pack/packer/start/";
        in
        {
          home.file."${packer_dir}packer.nvim".source = self.inputs.packer-nvim.outPath;
       };
    };
  };
}
