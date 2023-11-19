{
  imports = [
    ./modules/dev
    ./modules/fun
    ./modules/git
    ./modules/helix
    ./modules/k8s
    ./modules/nvim
    ./modules/tmux
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
