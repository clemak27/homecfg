# homecfg

This is my home-manager configuration. It was split of from my linux_setup,
since I use it on other places as well.

It configures basically all CLI tools I want and is split into modules that can be
enabled/disabled as needed.

## Usage

The flake provides a nixOS modules, which can be imported in an existing config.

<!-- markdownlint-disable-next-line -->
### homecfg

1. Add this input to you `flake.nix`:

   ```nix
   homecfg = {
     url = "github:clemak27/homecfg";
   };
   ```

2. Add it as module to you homeManagerConfiguration:

   ```nix
   modules = [
     homecfg.nixosModules.homecfg
     ...
   ];
   ```

3. For local development/changes to homecfg, use the absolute path to
   the checked out git repo, e.g. `url = "path:<path-to-homecfg>";`.
   After you changed something, update the input:
   `nix flake lock --update-input homecfg`

   Alternatively, you can also keep the lockfile as is and use:
   `home-manager switch --flake . --impure --override-input homecfg 'path:<path-to-homecfg>'"`

## Notes

### Aliases

some aliases that are useful:

```nix
{ name = "hms"; value = "home-manager switch --flake . --impure"; }
{ name = "hmsl"; value = "home-manager switch --flake . --impure --override-input homecfg 'path:<path-to-homecfg>'"; }
```

### Updating

It's useful to add a convenience-function to update home-mananger:

```nix
  updateHM = pkgs.writeShellScriptBin "update-homecfg" ''
    set -eo pipefail

    echo "Updating flake"
    nix flake update
    git add flake.nix flake.lock
    git commit -m "chore(flake): Update $(date -I)"

    echo "Reloading home-manager config"
    home-manager switch --flake . --impure

    echo "Collecting garbage"
    nix-collect-garbage

    echo "Updating nvim plugins"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  '';
```

### non-NixOS

If running on non NixOS systems, you need to add this to your .zshrc:

```nix
". $HOME/.nix-profile/etc/profile.d/nix.sh"
"export GIT_SSH=/usr/bin/ssh"
```
