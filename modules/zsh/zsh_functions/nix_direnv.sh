#!/bin/sh

__init_shell() {
  echo ".direnv" >> .gitignore
  nix flake new . -t github:nix-community/nix-direnv
  nvim flake.nix +12
  git add flake.nix
  direnv allow
}

__remove_shell() {
  git rm -f flake.lock .envrc flake.nix flake.lock
  rm -rf .direnv .envrc flake.nix flake.lock
}

# shellcheck disable=SC3033
nix-direnv() {
for arg in "$@"
do
  case $arg in
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
