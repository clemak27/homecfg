{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
in
{
  options.homecfg.k8s = {
    enable = lib.mkEnableOption "Manage kubernetes with home-manager";
  };

  config = lib.mkIf (cfg.k8s.enable) {

    home.packages = with pkgs; [
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      stern
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
      # use kubecolor if available (install on nix did not work)
      # go install github.com/hidetatz/kubecolor/cmd/kubecolor@latest
      if [ -e "$GOPATH/bin/kubecolor" ]; then
        source <(kubectl completion zsh)
        alias kubectl=kubecolor
        compdef kubecolor=kubectl
      fi

    '';
  };
}
