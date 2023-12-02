# homecfg

This is my home-manager configuration.

It configures basically all CLI tools I want and is split into modules that can
be enabled/disabled as needed.

## Usage

The flake provides a home-manager module, which can be imported in an existing
config.

Add this input to you `flake.nix`:

```nix
homecfg = {
  url = "github:clemak27/homecfg";
};
```

Add it as module to your `homeManagerConfiguration`:

```nix
modules = [
  homecfg.hmModules.homecfg
  ...
];
```

For local development/changes to `homecfg`, use the absolute path to the checked
out git repo when switching config, e.g.
`home-manager switch --flake . --impure --override-input homecfg 'path:<path-to-homecfg>'"`

## Notes

### Updating and `nixpkgs`

The versions of `nixpkgs` included here might not be up-to-date. It is suggested
to pin the versions to whatever you use in your flake like this:

```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

home-manager = {
  url = "github:nix-community/home-manager/master";
  inputs.nixpkgs.follows = "nixpkgs";
};
homecfg = {
  url = "github:clemak27/homecfg";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
};
```

### non-NixOS

If running on non NixOS systems, you need to add this to your `.zshrc`:

```nix
". $HOME/.nix-profile/etc/profile.d/nix.sh"
"export GIT_SSH=/usr/bin/ssh"
```
