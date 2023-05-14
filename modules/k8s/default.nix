{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
  starshipK8s = pkgs.writeShellScriptBin "starship-toggle-k8s" ''
        #!/bin/sh

        if [ -x "$(which starship)" ] ; then
          if [ -e "$HOME/.config/starship-k8s.toml" ] ; then
            if env | grep STARSHIP_CONFIG > /dev/null
            then
              unset STARSHIP_CONFIG
            else
              export STARSHIP_CONFIG="$HOME/.config/starship-k8s.toml"
            fi
          else
            echo "k8s config not found, generating..."
            {
            sed '/kubernetes/,$ d' "$HOME/.config/starship.toml"
            echo '[kubernetes]'
            echo 'disabled = false'
            echo 'symbol = "󱃾"'
            echo 'format = "[$symbol $context( ($namespace))]($style) "'
            echo ""
            echo "[line_break]"
            echo "disabled = false"
            echo ""
            sed '/memory_usage/,$ !d' "$HOME/.config/starship.toml"
        } > "$HOME/.config/starship-k8s.toml"

      fi
    else
      echo "starship not found"
    fi
  '';
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
      starshipK8s
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
        { name = "stk"; value = "source starship-toggle-k8s"; }
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
