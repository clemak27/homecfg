{
  imports = [
    ./modules/dev
    ./modules/fun
    ./modules/git
    ./modules/k8s
    ./modules/nvim
    ./modules/todo
    ./modules/tools
    ./modules/zsh
    ./modules/zellij
  ];

  config = {
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
  };

}
