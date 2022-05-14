# home-manager

This is my home-manager configuration. It was split of from my linux_setup,
since I use it on other places as well.

It configures basically all CLI tools I want and is split into modules that can be
enabled/disabled as needed.

Currently, it is intended to be used as a git-submodule or as extra repo,
maybe I will make a flake out of it eventually.

## Usage

1. Go to some repo where you want to use this config.
2. Add this repo as submodule: `git submodule add git@github.com:clemak27/home-manager.git`
3. create a `home.nix`, which imports the `homecfg.nix` file in this repo.
4. After this, you can use the `homecfg` config options to enable modules as needed.
5. When reloading the config and using flakes, you need to use `home-manager switch --flake '.?submodules=1' --impure`  
   (we will see when get around to making this more convenient ¯\\\_(ツ)_/¯)
