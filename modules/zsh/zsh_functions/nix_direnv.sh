#!/bin/sh

UPDATE_GITIGNORE=0
PERSIST_FLAKE=0

__init_shell() {
  if [ $UPDATE_GITIGNORE -eq 1 ]; then
    {
      echo ".direnv";
      echo ".envrc";
    } >> .gitignore
  fi

  nix flake new . -t github:nix-community/nix-direnv
  nvim flake.nix

  if [ $PERSIST_FLAKE -eq 1 ]; then
    git add flake.nix
  else
    # https://discourse.nixos.org/t/can-i-use-flakes-within-a-git-repo-without-committing-flake-nix/18196/5
    git add --intent-to-add flake.nix
    git update-index --assume-unchanged flake.nix
  fi

  direnv allow
}

__remove_shell() {
  rm -rf .direnv .envrc flake.nix flake.lock
  git update-index --remove flake.nix
  git rm -f flake.lock
}

# shellcheck disable=SC3033
nix-direnv() {
  for arg in "$@"
  do
    case $arg in
      -i|--ignore)
        UPDATE_GITIGNORE=1
        shift
        ;;
      -p|--persist)
        PERSIST_FLAKE=1
        shift
        ;;
      init)
        __init_shell
        shift
        ;;
      remove)
        __remove_shell
        shift
        ;;
    esac
  done
}
