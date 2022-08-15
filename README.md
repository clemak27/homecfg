# home-manager

This is my home-manager configuration. It was split of from my linux_setup,
since I use it on other places as well.

It configures basically all CLI tools I want and is split into modules that can be
enabled/disabled as needed.

Currently, it is intended to be used as a git-submodule or as extra repo,
maybe I will make a flake out of it eventually.

## Usage

### git submodule

1. Go to some repo where you want to use this config.
2. Add this repo as submodule:

   ```sh
   git submodule add git@github.com:clemak27/homecfg.git
   git submodule init homecfg
   git submodule update homecfg
   ```

3. create a `home.nix`, which imports the `default.nix` file in this repo.
4. After this, you can use the `homecfg` config options to enable modules as needed.
5. When reloading the config and using flakes, you need to use
   `home-manager switch --flake '.?submodules=1' --impure`
   (we will see when get around to making this more convenient ¯\\\_(ツ)_/¯)

### separate repo

1. Clone this repo somewhere
2. import the `default.nix` in your `home.nix` file (with an absolute path)

### flake-input

While this repo is not a flake, it can still leverage flakes to make updating
it more convenient than as a submodule/directory:

1. Add this input to you `flake.nix`:

   ```nix
   homecfg = {
     url = "github:clemak27/homecfg";
     flake = false;
   };
   ```

2. Add it as module to you homeManagerConfiguration:

   ```nix
   modules = [
     "${self.inputs.homecfg}/default.nix"
     ...
   ];
   ```

3. For local development/changes to homecfg, use the absolute path to
   the checked out git repo, e.g. `url = "path:/home/clemens/Projects/homecfg";`.
   After you changed something, update the input:
   `nix flake lock --update-input homecfg`

   Alternatively, you can also keep the lockfile as is and use:
   `nix flake update --override-input
   homecfg "path:/home/clemens/Projects/homecfg" &&
   home-manager switch --flake . --impure`

### home-manager as NixOS module

If you use home-manager as NixOS module, you need to add this
(there is probably a better way, but I have not figured it out yet):

```nix
home-manager.nixosModules.home-manager
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.clemens = { config, pkgs, lib, ... }:
  {
    imports = [
      "${self.inputs.homecfg}/default.nix"
      ./configurations/xyz/home.nix
    ];
  };
}
```

## Notes

### Aliases

some aliases that are useful:

```nix
{ name = "hms"; value = "home-manager switch --flake '.?submodules=1' --impure"; }
{ name = "hmsl"; value = "nix flake update --override-input homecfg 'path:/home/clemens/Projects/homecfg' && home-manager switch --flake '.?submodules=1' --impure && git restore flake.lock"; }
```

### Updating

It's useful to add a convenience-function to update home-mananger:

```nix
  updateHM = pkgs.writeShellScriptBin "update-homecfg" ''
    echo "Updating flake"
    nix flake update
    git add flake.nix flake.lock
    git commit -m "chore(flake): Update $(date -I)"

    echo "Reloading home-manager config"
    home-manager switch --flake '.?submodules=1' --impure

    echo "Collecting garbage"
    nix-collect-garbage

    echo "Updating tealdeer cache"
    tldr --update

    echo "Updating nvim plugins"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  '';
```

### NixOS vs HM

If running on non NixOS systems, you need to add this to your .zshrc:

```nix
". $HOME/.nix-profile/etc/profile.d/nix.sh"
"export GIT_SSH=/usr/bin/ssh"
```
