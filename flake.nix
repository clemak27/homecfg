{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, pre-commit-hooks }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system:
        import nixpkgs { inherit system; });
    in
    {
      hmModules.homecfg = { ... }: {
        imports = [
          ./modules/dev
          ./modules/fun
          ./modules/git
          ./modules/k8s
          ./modules/nvim
          ./modules/todo
          ./modules/tools
          ./modules/zsh
          ./modules/zellij
        ];

        config = {
          programs.home-manager.enable = true;
          nixpkgs.config.allowUnfree = true;
        };
      };

      checks = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              editorconfig-checker.enable = true;
              nixpkgs-fmt.enable = true;

              conventional_commits = {
                enable = true;
                name = "commit message";
                description = ''
                  Check whether the current commit message follows commiting rules.
                '';
                entry =
                  let
                    script = pkgs.writeShellScript "pre-commit-conventional" ''
                      commit_msg=$(cat "$1")
                      regex="^(fixup! )?(build|chore|ci|docs|feat|feat!|fix|perf|refactor|revert|style|test)(\(.*\))?: .*$"
                      error="Commit message does not conform to regex: $regex"
                      [[ "$commit_msg" =~ $regex ]] && exit 0 || (echo $error && exit 1)
                    '';
                  in
                  toString
                    script;
                stages = [ "commit-msg" ];
              };
            };
          };
        });

      devShells = forAllSystems
        (system: {
          default = nixpkgsFor.${system}.mkShell
            {
              shellHook = (self.checks.${system}.pre-commit-check.shellHook);
            };
        });
    };
}

