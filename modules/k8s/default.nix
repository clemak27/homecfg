{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
  watchk8s = pkgs.writeShellScriptBin "wk" ''
    ${pkgs.viddy}/bin/viddy --no-title kubecolor --force-colors "$@"
  '';
in
{
  imports = [
    ./k9s.nix
  ];

  options.homecfg.k8s = {
    enable = lib.mkEnableOption "Manage kubernetes with home-manager";
  };

  config = lib.mkIf (cfg.k8s.enable) {

    home.packages = with pkgs; [
      krew
      kubectl
      kubectx
      kubernetes-helm
      kubecolor
      kustomize
      stern

      watchk8s
    ];

    programs.zsh.oh-my-zsh.plugins = [
      "kubectl"
    ];

    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "kgaw"; value = "[ -e $GOPATH/bin/kubecolor ] && watch -n 1 --no-title kubecolor get all --force-colors ||  watch -n 1 --no-title kubectl get all"; }
        { name = "kns"; value = "kubens"; }
        { name = "kctx"; value = "kubectx"; }
      ]
    );

    programs.zsh.initExtra = ''
      source <(kubecolor completion zsh)
      alias kubectl=kubecolor
      compdef kubecolor=kubectl

      # https://github.com/ohmyzsh/ohmyzsh/issues/12515
      unalias k &> /dev/null || :
      function k() { kubectl "$@" }
      compdef _kubectl k

      export PATH="$HOME/.krew/bin:$PATH"
    '';
  };
}
