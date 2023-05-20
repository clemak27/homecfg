# homecfg

This is my home-manager configuration.

It configures basically all CLI tools I want and is split into modules that can
be enabled/disabled as needed.

## Usage

The flake provides a NixOS module, which can be imported in an existing config.

1. Add this input to you `flake.nix`:

   ```nix
   homecfg = {
     url = "github:clemak27/homecfg";
   };
   ```

2. Add it as module to your `homeManagerConfiguration`:

   ```nix
   modules = [
     homecfg.nixosModules.homecfg
     ...
   ];
   ```

3. For local development/changes to `homecfg`, use the absolute path to the
   checked out git repo when switching config, e.g.
   `home-manager switch --flake . --impure --override-input homecfg 'path:<path-to-homecfg>'"`

## Notes

### Updating and nixpkgs

Managing the `nixpkgs` config you use is out of scope for this project and is
part of your setup. This is just a module.

Note that if you want to update just `homecfg`, instead of your whole flake, use
`nix flake lock --update-input homecfg`.

### Aliases

some aliases that are useful:

```nix
{ name = "hms"; value = "home-manager switch --flake . --impure"; }
{ name = "hmsl"; value = "home-manager switch --flake . --impure --override-input homecfg 'path:<path-to-homecfg>'"; }
```

### non-NixOS

If running on non NixOS systems, you need to add this to your `.zshrc`:

```nix
". $HOME/.nix-profile/etc/profile.d/nix.sh"
"export GIT_SSH=/usr/bin/ssh"
```
